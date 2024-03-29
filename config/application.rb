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

if RUBY_PLATFORM.match?(/wasm/)
  require "anycable-rails"
  require "turbo-rails"
  require "propshaft"
  require "nanoid"
else
  Bundler.require(*Rails.groups)
end

module AnycableRailsDemo
  class Application < Rails::Application
    config.load_defaults 7.0

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
