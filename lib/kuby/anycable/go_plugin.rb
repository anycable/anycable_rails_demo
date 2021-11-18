# frozen_string_literal: true

module Kuby
  module AnyCable
    class GoPlugin < ::Kuby::Plugin
      extend ::KubeDSL::ValueFields

      ROLE = "ws"

      value_fields :replicas
      value_fields :redis_url
      value_fields :port
      value_fields :metrics_port
      value_fields :rpc_host
      value_fields :ws_path
      value_fields :image
      value_fields :hostname

      DEFAULT_IMAGE = "anycable/anycable-go:1.1"

      def after_initialize
        @replicas = 1
        @metrics_port = 5001
        @rpc_host = nil
        @redis_url = nil
        @ws_path = "/cable"
        @port = 8081
        @hostname = nil
        @image = DEFAULT_IMAGE
      end

      def after_configuration
        configure_rpc_host
        configure_redis_url

        if rails_spec
          @hostname ||= rails_spec.hostname
          configure_ingress(rails_spec.ingress, hostname)
        end
      end

      def configure(&block)
        instance_eval(&block) if block
      end

      def resources
        @resources ||= [
          service_account,
          service,
          config_map,
          deployment
        ]
      end

      def configure_ingress(ingress, hostname)
        spec = self

        ingress.spec.rule do
          host hostname

          http do
            path do
              path spec.ws_path

              backend do
                service_name spec.service.metadata.name
                service_port spec.service.spec.ports.first.port
              end
            end
          end
        end
      end

      def service_account(&block)
        context = self

        @service_account ||= KubeDSL.service_account do
          metadata do
            name "#{context.selector_app}-#{ROLE}-sa"
            namespace context.namespace.metadata.name

            labels do
              add :app, context.selector_app
              add :role, ROLE
            end
          end
        end

        @service_account.instance_eval(&block) if block
        @service_account
      end

      def service(&block)
        spec = self

        @service ||= KubeDSL.service do
          metadata do
            name "#{spec.selector_app}-#{ROLE}-svc"
            namespace spec.namespace.metadata.name

            labels do
              add :app, spec.selector_app
              add :role, ROLE
            end
          end

          spec do
            type "ClusterIP"

            selector do
              add :app, spec.selector_app
              add :role, ROLE
            end

            port do
              name "http"
              port spec.port
              protocol "TCP"
              target_port "http"
            end

            if spec.metrics_port
              port do
                name "metrics"
                port spec.metrics_port
                protocol "TCP"
                target_port "metrics"
              end
            end
          end
        end

        @service.instance_eval(&block) if block
        @service
      end

      def deployment(&block)
        context = self

        @deployment ||= KubeDSL.deployment do
          metadata do
            name "#{context.selector_app}-#{ROLE}"
            namespace context.namespace.metadata.name

            labels do
              add :app, context.selector_app
              add :role, ROLE
            end
          end

          spec do
            replicas context.replicas

            selector do
              match_labels do
                add :app, context.selector_app
                add :role, ROLE
              end
            end

            strategy do
              type "RollingUpdate"

              rolling_update do
                max_surge "25%"
                max_unavailable 0
              end
            end

            template do
              metadata do
                labels do
                  add :app, context.selector_app
                  add :role, ROLE
                end
              end

              spec do
                container(:ws) do
                  name "#{context.selector_app}-#{ROLE}"
                  image context.image
                  image_pull_policy "IfNotPresent"

                  port do
                    container_port context.port
                    name "http"
                    protocol "TCP"
                  end

                  if context.metrics_port
                    port do
                      container_port context.metrics_port
                      name "metrics"
                      protocol "TCP"
                    end
                  end

                  env_from do
                    config_map_ref do
                      name context.config_map.metadata.name
                    end
                  end

                  readiness_probe do
                    success_threshold 1
                    failure_threshold 3
                    initial_delay_seconds 15
                    period_seconds 10
                    timeout_seconds 3

                    tcp_socket do
                      port "http"
                    end
                  end

                  liveness_probe do
                    success_threshold 1
                    failure_threshold 3
                    initial_delay_seconds 90
                    period_seconds 10
                    timeout_seconds 3

                    tcp_socket do
                      port "http"
                    end
                  end
                end

                image_pull_secret do
                  name context.kubernetes.registry_secret.metadata.name
                end

                restart_policy "Always"
                service_account_name context.service_account.metadata.name
              end
            end
          end
        end

        @deployment.instance_eval(&block) if block
        @deployment
      end

      def config_map(&block)
        spec = self

        @config_map ||= KubeDSL.config_map do
          metadata do
            name "#{spec.selector_app}-#{ROLE}-config"
            namespace spec.namespace.metadata.name
          end

          data do
            if spec.rpc_host
              add "ANYCABLE_RPC_HOST", spec.rpc_host
            end

            if spec.redis_url
              add "ANYCABLE_REDIS_URL", spec.redis_url
            end

            add "ANYCABLE_HOST", "0.0.0.0"
            add "ANYCABLE_PORT", spec.port.to_s

            if spec.metrics_port
              add "ANYCABLE_METRICS_PORT", spec.metrics_port.to_s
              add "ANYCABLE_METRICS_HTTP", "/metrics"
            end
          end
        end

        @config_map.instance_eval(&block) if block
        @config_map
      end

      alias_method :env, :config_map

      delegate :kubernetes, to: :environment

      delegate :docker, to: :environment

      delegate :selector_app, to: :kubernetes

      delegate :namespace, to: :kubernetes

      def rpc_spec
        @rpc_spec ||= kubernetes.plugin(:anycable_rpc)
      end

      def rails_spec
        @rails_spec ||= kubernetes.plugin(:rails_app)
      end

      def configure_rpc_host
        return if config_map.data.get("ANYCABLE_RPC_HOST")
        # Make it possible to avoid setting RPC host at all
        return if rpc_host == false

        return unless rpc_spec

        config_map.data.add("ANYCABLE_RPC_HOST", "dns:///#{rpc_spec.service.metadata.name}:50051")
      end

      def configure_redis_url
        return if config_map.data.get("REDIS_URL") || config_map.data.get("ANYCABLE_REDIS_URL")
        # Make it possible to avoid setting Redis url at all
        return if redis_url == false

        # Try to lookup Redis url from the RPC and Web app specs
        [rpc_spec, rails_spec].compact.detect do |spec|
          %w[ANYCABLE_REDIS_URL REDIS_URL].detect do |env_key|
            url = spec.config_map.data.get(env_key)
            next unless url

            config_map.data.add("ANYCABLE_REDIS_URL", url)
            true
          end
        end
      end
    end
  end
end
