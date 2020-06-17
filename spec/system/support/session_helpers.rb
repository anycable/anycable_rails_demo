# frozen_string_literal: true

module SessionHelpers
  def within_session(...)
    Capybara.using_session(...)
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
