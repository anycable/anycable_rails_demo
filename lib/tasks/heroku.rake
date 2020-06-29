# frozen_string_literal: true

require "net/http"

# A Rake task to run during the Heroku release phase
task "heroku:release" => ["db:migrate", "heroku:sync_configs"]

namespace :heroku do
  task :sync_configs do
    # The name or ID of the connected RPC app
    rpc_app = ENV["HEROKU_ANYCABLE_RPC_APP"]
    # We retrieve the name of the current app from the Heroku metadata.
    # NOTE: You must enable runtime-dyno-metadata feature. See https://devcenter.heroku.com/articles/dyno-metadata
    #
    # Enable via CLI:
    #   heroku labs:enable runtime-dyno-metadata -a <app-name>
    current_app = ENV["HEROKU_APP_ID"]
    next unless rpc_app && current_app

    # Use Heroku CLI to generate a token:
    #    heroku auth:token
    token = ENV.fetch("HEROKU_API_TOKEN")

    fetch_config = proc do |app|
      uri = URI.parse("https://api.heroku.com/apps/#{app}/config-vars")
      header = {
        "Accept": "application/vnd.heroku+json; version=3",
        "Authorization": "Bearer #{token}"
      }

      req = Net::HTTP::Get.new(uri.request_uri, header)

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      raise "Failed to fetch config vars for the current app: #{res.value}\n#{res.body}" unless res.is_a?(Net::HTTPSuccess)

      JSON.parse(res.body).tap do |config|
        # remove all Heroku metadata
        config.delete_if { |k, _| k.start_with?("HEROKU_") }
      end
    end

    current_config = fetch_config.call(current_app).tap do |config|
      # remove protected RPC vars we don't want to sync
      %w[].each { |k| config.delete(k) }
    end

    rpc_config = fetch_config.call(rpc_app).tap do |config|
      # remove protected RPC vars we don't want to update/remove
      %w[ANYCABLE_DEPLOYMENT ANYCABLE_HOST].each { |k| config.delete(k) }
    end

    keys_to_delete = rpc_config.keys - current_config.keys
    missing_keys = current_config.keys - rpc_config.keys
    sync_keys = (current_config.keys - missing_keys).select { |k| current_config[k] != rpc_config[k] }

    $stdout.puts "RPC only keys: #{keys_to_delete.join(", ")}" unless keys_to_delete.empty?
    $stdout.puts "APP only keys: #{missing_keys.join(", ")}" unless missing_keys.empty?
    $stdout.puts "Out-of-sync keys: #{sync_keys.join(", ")}" unless sync_keys.empty?

    payload = Hash[keys_to_delete.map { |k| [k, nil] } + (sync_keys + missing_keys).map { |k| [k, current_config[k]] }]

    uri = URI.parse("https://api.heroku.com/apps/#{rpc_app}/config-vars")
    header = {
      "Accept": "application/vnd.heroku+json; version=3",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{token}"
    }

    req = Net::HTTP::Patch.new(uri.request_uri, header)
    req.body = payload.to_json

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    raise "Failed to update config vars for the RPC app: #{res.value}\n#{res.body}" unless res.is_a?(Net::HTTPSuccess)
  end
end
