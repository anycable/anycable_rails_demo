# frozen_string_literal: true

module SessionHelpers
  def within_session(...)
    Capybara.using_session(...)
  end

  def mark_all_banners_as_read!
    visit "/" unless current_path == "/"
    page.driver.browser.manage.add_cookie(name: "show_banners", value: "N")
  end
end

RSpec.configure do |config|
  config.include SessionHelpers, type: :system

  config.before(type: :system) do
    mark_all_banners_as_read!
  end
end
