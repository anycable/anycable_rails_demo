# frozen_string_literal: true

require "active_support/core_ext"
require "active_support/encrypted_configuration"

require "kuby"
require "kuby/digitalocean"

METRICS_PORT = 5100

Kuby.define("anycable-rails-demo") do
  environment(:production) do
    app_creds = ActiveSupport::EncryptedConfiguration.new(
      config_path: "./config/credentials/production.yml.enc",
      key_path: "./config/credentials/production.key",
      env_key: "RAILS_MASTER_KEY",
      raise_if_missing_key: true
    )

    docker do
      base_image "ruby:3.0.1"
      gemfile "./Gemfile"

      webserver_phase.webserver = :puma

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

        metrics_port = 5100

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
            add "PROMETHEUS_EXPORTER_PORT", metrics_port.to_s
          end
        end
      end

      provider :digitalocean do
        access_token app_creds[:do_token]
        cluster_id "80e27796-3b3b-4655-b346-41c06bc61ded"
      end
    end
  end
end
