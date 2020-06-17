# frozen_string_literal: true

# Rails is not flexible enough; at least for now(
module BetterRailsSystemTests
  # Use our `Capybara.save_path` to store screenshots with other capybara artifacts
  # (Rails screenshots path is not configurable https://github.com/rails/rails/blob/49baf092439fc74fc3377b12e3334c3dd9d0752f/actionpack/lib/action_dispatch/system_testing/test_helpers/screenshot_helper.rb#L79)
  def absolute_image_path
    Rails.root.join("#{Capybara.save_path}/screenshots/#{image_name}.png")
  end

  # Make failure screenshots compatible with multi-session setup
  def take_screenshot
    return super unless Capybara.last_used_session
    Capybara.using_session(Capybara.last_used_session) { super }
  end

  # Convert dom_id to selector
  def dom_id(*args)
    "##{super}"
  end
end

RSpec.configure do |config|
  # Add #dom_id support
  config.include ActionView::RecordIdentifier, type: :system
  config.include BetterRailsSystemTests, type: :system

  # Make urls in mailers contain the correct server host
  config.around(:each, type: :system) do |ex|
    was_host, Rails.application.default_url_options[:host] = Rails.application.default_url_options[:host], Capybara.server_host
    ex.run
    Rails.application.default_url_options[:host] = was_host
  end

  # Make sure this hook runs before others
  config.prepend_before(:each, type: :system) do
    # Use JS driver always
    driven_by Capybara.javascript_driver
  end
end
