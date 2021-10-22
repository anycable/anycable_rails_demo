# frozen_string_literal: true

require "active_support/core_ext"
require "active_support/encrypted_configuration"

require "kuby"
require "kuby/digitalocean"

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

        env do
          data do
            add "SECRET_KEY_BASE", app_creds[:secret_key_base]
            add "DATABASE_URL", app_creds[:database_url]
            add "REDIS_URL", app_creds[:redis_url]
            add "ACTION_CABLE_ADAPTER", "redis"
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
