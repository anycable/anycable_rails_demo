# frozen_string_literal: true

module LoginHelpers
  def login_user(name)
    page.driver.set_cookie(
      :uid,
      [name, Nanoid.generate(size: 3)].join("/")
    )
  end

  def logout() = page.driver.clear_cookies
end

RSpec.configure do |config|
  config.include LoginHelpers, type: :system

  config.before(:each, type: :system) do |ex|
    unless ex.metadata[:auth] == false
      login_user "Any"
    end
  end
end
