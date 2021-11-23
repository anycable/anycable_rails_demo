# frozen_string_literal: true

require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "active_job/railtie"

require "active_support/core_ext/integer/time"

Bundler.require(*Rails.groups)

module AnycableRailsDemo
  class Application < Rails::Application
    config.load_defaults 6.0

    # Make sure Tailwind JIT is not running file watcher
    # (which makes bin/webpack to hang forever)
    Webpacker::Compiler.env["TAILWIND_MODE"] = "build"

    config.generators do |g|
      g.assets false
      g.helper false
      g.orm :active_record
      g.stylesheets false
      g.javascripts false
      g.test_framework nil
    end

    server do
      next unless ENV["HTTP_LIVENESS_PORT"]

      port = ENV.fetch("HTTP_LIVENESS_PORT").to_i
      path = ENV.fetch("HTTP_LIVENESS_PATH", "/i_feel_so_alive")

      # Liveness check server
      require "webrick"

      logger = Logger.new(ENV["LOG"] == "1" ? $stdout : IO::NULL)

      WEBrick::HTTPServer.new(
        Port: port,
        Logger: logger,
        AccessLog: []
      ).tap do |http_server|
        http_server.mount_proc path do |_, res|
          res.status = 200
          res.body = "Ready"
        end
      end.then do |http_server|
        Thread.new { http_server.start }
        logger.info(
          "HTTP health server is listening on localhost:#{port} and mounted at \"#{path}\""
        )
      end
    end
  end
end
