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

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins "*"
        resource "*", headers: :any, methods: [:get, :post, :patch, :put]
      end
    end

    config.generators do |g|
      g.assets false
      g.helper false
      g.orm :active_record
      g.stylesheets false
      g.javascripts false
      g.test_framework nil
    end
  end
end
