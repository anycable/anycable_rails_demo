# frozen_string_literal: true

require "active_support/core_ext"
require "active_support/encrypted_configuration"

module Kuby
  class Environment
    def read_creds(environment = Kuby.env)
      ActiveSupport::EncryptedConfiguration.new(
        config_path: "./config/credentials/#{environment}.yml.enc",
        key_path: "./config/credentials/#{environment}.key",
        env_key: "RAILS_MASTER_KEY",
        # Temp: do not raise on a missing key to allow assets image to copy assets
        # See: https://github.com/getkuby/kuby-core/pull/63
        raise_if_missing_key: false
      ) || {}
    end
  end
end
