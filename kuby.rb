# frozen_string_literal: true

require "active_support/core_ext/hash/indifferent_access"
require "active_support/encrypted_configuration"

require "kuby"
require "kuby/digitalocean"

$LOAD_PATH << "./lib"
require "kuby/anycable"

METRICS_PORT = 5100

Kuby.define("anycable-rails-demo") do
  environment(:production) do
    app_creds = ActiveSupport::EncryptedConfiguration.new(
      config_path: "./config/credentials/production.yml.enc",
      key_path: "./config/credentials/production.key",
      env_key: "RAILS_MASTER_KEY",
      # Temp: do not raise on a missing key to allow assets image to copy assets
      # See: https://github.com/getkuby/kuby-core/pull/63
      raise_if_missing_key: false
    ) || {}

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
        replicas 3

        service do
          spec do
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
            add "DATABASE_URL", app_creds[:database_url]
            add "REDIS_URL", app_creds[:redis_url]
            add "ACTION_CABLE_ADAPTER", "any_cable"
            add "PROMETHEUS_EXPORTER_PORT", METRICS_PORT.to_s
          end
        end
      end

      add_plugin :anycable_rpc do
        metrics_port METRICS_PORT
        replicas 2
      end

      add_plugin :anycable_go do
        replicas 2
      end

      provider :digitalocean do
        access_token app_creds[:do_token]
        cluster_id app_creds[:do_cluster_id]
      end
    end
  end
end
