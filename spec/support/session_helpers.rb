# frozen_string_literal: true

module SessionHelpers
  def within_session(name, &block)
    Capybara.using_session(name) do
      @last_active_session = name
      block.call
      @last_active_session = nil
    end
  end

  # Make failure screenshots compatible with multi-session setup
  def take_screenshot
    return super unless @last_active_session
    Capybara.using_session(@last_active_session) { super }
  end

  def mark_all_banners_as_read!
    page.driver.set_cookie "show_banners", "N"
  end
end

RSpec.configure do |config|
  config.include SessionHelpers, type: :system

  config.before(type: :system) do
    mark_all_banners_as_read!
  end
end
