# frozen_string_literal: true

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Enforce AnyCable patches to make it possible to use any_cable adapter for system tests
  require "anycable/rails/actioncable/connection"

  # Specify AnyCable WebSocket server URL to use by JS client
  config.after_initialize do
    config.action_cable.url = ActionCable.server.config.url = ENV.fetch("CABLE_URL", "ws://localhost:8080/cable")
  end

  config.action_cable.mount_path = nil

  # Settings specified here will take precedence over those in config/application.rb.
  config.cache_classes = true

  # Always eager load in tests
  config.eager_load = true

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }

  # Do not log in tests
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(nil))
  config.log_level = :fatal

  # Disable caching and do not show errors (since we're only using system tests)
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = ENV["DEBUG"] != "1"

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations.
  # config.action_view.raise_on_missing_translations = true
end
