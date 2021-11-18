# frozen_string_literal: true

require "active_support/core_ext/hash/indifferent_access"
require "active_support/encrypted_configuration"

require "kuby"
require "kuby/digitalocean"

$LOAD_PATH << "./lib"
require "kuby/prometheus_service_monitor"
require "kuby/appless"

Kuby.define("anycable-rails-demo") do
  environment(:production) do
    app_creds = ActiveSupport::EncryptedConfiguration.new(
      config_path: "./config/credentials/production.yml.enc",
      key_path: "./config/credentials/production.key",
      env_key: "RAILS_MASTER_KEY",
      raise_if_missing_key: true
    )

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
