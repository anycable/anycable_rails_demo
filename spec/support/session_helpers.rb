# frozen_string_literal: true

module SessionHelpers
  def within_session(name, &block)
    Capybara.using_session(name, &block)
  end
end

RSpec.configure do |config|
  config.include SessionHelpers, type: :system
end
