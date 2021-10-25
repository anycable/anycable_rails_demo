# frozen_string_literal: true

require "kuby"
require "kuby/digitalocean"

$LOAD_PATH << "./lib"
require "kuby/prometheus_service_monitor"
require "kuby/anycable"
require "kuby/appless"
require "kuby/creds"

METRICS_PORT = 5100

Kuby.define("anycable-rails-demo") do
  environment(:production) do
    app_creds = read_creds(:production)

    docker do
      base_image "ruby:3.0.1"
      gemfile "./Gemfile"

      webserver_phase.webserver = :puma
      bundler_phase.gemfiles "./gemfiles/kuby.gemfile"

      credentials do
        username app_creds[:do_token]
        password app_creds[:do_token]
      end

      image_url "registry.digitalocean.com/anycable/anycable-rails-demo"
    end

    kubernetes do
      add_plugin :rails_app do
        hostname "kuby-demo.anycable.io"
        manage_database false

        service do
          spec do
            # Metrics port
            port do
              name "metrics"
              port METRICS_PORT
              protocol "TCP"
              target_port "metrics"
            end
          end
        end

        deployment do
          spec do
            template do
              spec do
                container(:web) do
                  port do
                    container_port METRICS_PORT
                    name "metrics"
                    protocol "TCP"
                  end
                end
              end
            end
          end
        end

        env do
          data do
            add "RAILS_LOG_TO_STDOUT", "enabled"
            add "RAILS_LOG_LEVEL", "debug"
            add "DATABASE_URL", app_creds[:database_url]
            add "REDIS_URL", app_creds[:redis_url]
            add "ACTION_CABLE_ADAPTER", "redis"
            add "PROMETHEUS_EXPORTER_PORT", METRICS_PORT.to_s
          end
        end
      end

      add_plugin :anycable do
        metrics_port METRICS_PORT
        replicas 2
      end

      provider :digitalocean do
        access_token app_creds[:do_token]
        cluster_id app_creds[:do_cluster_id]
      end
    end
  end

  environment(:monitoring) do
    app_creds = read_creds(:production)

    kubernetes_appless do
      namespace do
        metadata do
          name "kube-prometheus-stack"
        end
      end

      add_plugin :prometheus_service_monitor do
        monitor do
          spec do
            selector do
              match_labels do
                add :app, "anycable-rails-demo"
              end
            end

            namespace_selector do
              match_names "anycable-rails-demo-production"
            end

            endpoint do
              port "metrics"
            end
          end
        end
      end

      provider :digitalocean do
        access_token app_creds[:do_token]
        cluster_id app_creds[:do_cluster_id]
      end
    end
  end
end
