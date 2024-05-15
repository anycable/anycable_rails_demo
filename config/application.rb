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

require_relative "../lib/iodine/action_cable"

module AnycableRailsDemo
  class Application < Rails::Application
    config.load_defaults 7.0

    config.action_cable.mount_path = nil
    config.action_cable.url = "/cable"

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
