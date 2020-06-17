# frozen_string_literal: true

# Cuprite is a modern Capybara driver which uses Chrome CDP API
# instead of Selenium & co.
# See https://github.com/rubycdp/cuprite
require "capybara/cuprite"

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    **{
      window_size: [1200, 800],
      browser_options: {},
      # Increase Chrome startup timeout for CI
      process_timeout: 10,
      inspector: true,
      # Allow running Chrome in a headful mode by setting HEADLESS env
      # var to a falsey value
      headless: !ENV["HEADLESS"].in?(%w[n 0 no false])
    }
  )
end

Capybara.default_driver = Capybara.javascript_driver = :cuprite

# Add shortcuts for cuprite-specific debugging helpers
module CupriteHelpers
  def pause
    page.driver.pause
  end

  def debug(binding = nil)
    page.driver.debug(binding)
  end
end

RSpec.configure do |config|
  config.include CupriteHelpers, type: :system
end
