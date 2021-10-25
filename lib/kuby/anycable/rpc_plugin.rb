# frozen_string_literal: true

module Kuby
  module AnyCable
    class RPCPlugin < ::Kuby::Plugin
      extend ::KubeDSL::ValueFields

      ROLE = "rpc"

      value_fields :replicas
      value_fields :redis_url
      value_fields :metrics_port
      value_fields :max_connection_age
      value_fields :rpc_pool_size

      def after_initialize
        @replicas = 1
        @metrics_port = nil
        @max_connection_age = 300000
        @rpc_pool_size = nil
      end

      def after_configuration
        return unless rails_spec

        deployment.spec.template.spec.container(:rpc).merge!(
          rails_spec.deployment.spec.template.spec.container(:web), fields: [:env_from]
        )
      end

      def configure(&block)
        instance_eval(&block) if block
      end

      def before_deploy(manifest)
        image_with_tag = "#{docker.image.image_url}:#{kubernetes.tag || Kuby::Docker::LATEST_TAG}"

        deployment do
          spec do
            template do
              spec do
                container(:rpc) do
                  image image_with_tag
                end
              end
            end
          end
        end
      end

      def resources
        @resources ||= [
          service_account,
          service,
          config_map,
          deployment
        ]
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
            cluster_ip "None"

            selector do
              add :app, spec.selector_app
              add :role, ROLE
            end

            port do
              name "rpc"
              port 50051
              protocol "TCP"
              target_port "rpc"
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
                container(:rpc) do
                  name "#{context.selector_app}-#{ROLE}"
                  image_pull_policy "IfNotPresent"
                  command %w[bundle exec anycable]

                  port do
                    container_port 50051
                    name "grpc"
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
            add "ANYCABLE_RPC_HOST", "0.0.0.0:50051"
            if spec.redis_url
              add "ANYCABLE_REDIS_URL", spec.redis_url
            end
            add "ANYCABLE_RPC_SERVER_ARGS__MAX_CONNECTION_AGE_MS", spec.max_connection_age.to_s

            if spec.rpc_pool_size
              add "ANYCABLE_RPC_POOL_SIZE", spec.rpc_pool_size.to_s
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

      def rails_spec
        @rails_spec ||= kubernetes.plugin(:rails_app)
      end
    end
  end
end
