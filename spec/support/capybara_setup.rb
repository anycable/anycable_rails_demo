# frozen_string_literal: true

require "capybara/rspec"

# Capybara settings (not covered by Rails system tests)

# Use 0.0.0.0:3002 to make it possible to access
# the test server from the outside world
Capybara.server_host = `hostname`.strip&.downcase || "0.0.0.0"
Capybara.server_port = 3002

# Don't wait too long in `have_xyz` matchers
Capybara.default_max_wait_time = 2

# Normalizes whitespaces when using `has_text?` and similar matchers
Capybara.default_normalize_ws = true

# Where to store artifacts (e.g. screenshots)
Capybara.save_path = "./tmp/capybara_output"

# Save capybara screenshots to circleci artifacts dir if present
if ENV["CIRCLE_ARTIFACTS"]
  Capybara.save_path = ENV["CIRCLE_ARTIFACTS"]
end

# Re-raise server errors instead of ignoring them
Capybara.raise_server_errors = ENV["DEBUG"] == "1"

Capybara.configure do |config|
  config.server = :puma, {Silent: true}
end
