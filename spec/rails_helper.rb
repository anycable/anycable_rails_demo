# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"

require "spec_helper"

begin
  require File.expand_path("../../config/environment", __FILE__)
rescue => e
  # Fail fast if application couldn't be loaded
  $stdout.puts "Failed to load the app: #{e.message}\n#{e.backtrace.take(5).join("\n")}"
  exit(1)
end

# Prevent from running in non-test environment
abort("The Rails environment is running in #{Rails.env} mode!") unless Rails.env.test?

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

require "test_prof/recipes/logging"
TestProf.activate("LOG", "all") do
  ::ActionCable.server.config.logger = TestProf::Rails::LoggingHelpers.logger
end

require "rspec/rails"

# support/ files contain framework configurations and helpers
Dir[File.join(__dir__, "support/**/*.rb")].sort.each { |file| require file }

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # Wrap each example into a transaction to avoid DB state leak
  config.use_transactional_fixtures = true

  # See https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  config.define_derived_metadata(file_path: %r{/spec/}) do |metadata|
    # do not overwrite type if it's already set
    next if metadata.key?(:type)

    match = metadata[:location].match(%r{/spec/([^/]+)/})
    metadata[:type] = match[1].singularize.to_sym
  end

  unless ENV["FULLTRACE"]
    config.filter_rails_from_backtrace!

    # Request/Rack middlewares
    config.filter_gems_from_backtrace "railties", "rack", "rack-test"
  end

  # Add `travel_to`
  # See https://andycroll.com/ruby/replace-timecop-with-rails-time-helpers-in-rspec/
  config.include ActiveSupport::Testing::TimeHelpers

  config.after do
    # Make sure every example starts with the current time
    travel_back

    # Clear ActiveJob jobs
    if defined?(ActiveJob) && ActiveJob::QueueAdapters::TestAdapter === ActiveJob::Base.queue_adapter
      ActiveJob::Base.queue_adapter.enqueued_jobs.clear
      ActiveJob::Base.queue_adapter.performed_jobs.clear
    end

    if defined?(ActionMailer)
      # Clear deliveries
      ActionMailer::Base.deliveries.clear
    end
  end
end
