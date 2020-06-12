# frozen_string_literal: true

# Rails is not flexible enough; at least for now(
module BetterRailsSystemTests
  # Use our `Capybara.save_path` to store images (required for CircleCI artifacts)
  # (Rails screenshots path is not configurable https://github.com/rails/rails/blob/49baf092439fc74fc3377b12e3334c3dd9d0752f/actionpack/lib/action_dispatch/system_testing/test_helpers/screenshot_helper.rb#L79)
  def absolute_image_path
    Rails.root.join("#{Capybara.save_path}/#{image_name}.png")
  end

  # Generate clickable paths for VS Code
  def display_image
    path = Pathname.new(image_path)
    path = path.relative_path_from(Rails.root) unless path.relative?
    "🖼  [Screenshot]: #{path}\n"
  end
end

RSpec.configure do |config|
  config.include BetterRailsSystemTests, type: :system

  # Make urls in mailers contain the correct server host
  config.around(:each, type: :system) do |ex|
    was_host, Rails.application.default_url_options[:host] = Rails.application.default_url_options[:host], Capybara.server_host
    ex.run
    Rails.application.default_url_options[:host] = was_host
  end

  config.before(:each, type: :system) do
    # Rails sets host to `127.0.0.1` for every test by default.
    # That would break in Docker
    host! "http://#{Capybara.server_host}"
    # Use JS driver always
    driven_by Capybara.javascript_driver
  end
end
