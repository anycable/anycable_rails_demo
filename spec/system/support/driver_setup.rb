# frozen_string_literal: true

REMOTE_SELENIUM_URL = ENV["SELENIUM_URL"]
REMOTE_SELENIUM_HOST, REMOTE_SELENIUM_PORT =
  if REMOTE_SELENIUM_URL
    URI.parse(REMOTE_SELENIUM_URL).yield_self do |uri|
      [uri.host, uri.port]
    end
  end

# Check whether the remote chrome is running and configure the Capybara
# driver for it.
remote_chrome =
  begin
    if REMOTE_SELENIUM_URL.nil?
      false
    else
      Socket.tcp(REMOTE_SELENIUM_HOST, REMOTE_SELENIUM_PORT, connect_timeout: 1).close
      true
    end
  rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError
    false
  end

CHROME_HEADLESS = !%w[0 no false].include?(ENV["HEADLESS"])

# Options to run local chrome with
# See https://github.com/GoogleChrome/puppeteer/issues/1645#issuecomment-356060348
CHROME_OPTIONS = %w[
  --window-size=1400,1400
  --no-sandbox
  --disable-dev-shm-usage
  --disable-default-apps
  --disable-extensions
  --disable-sync
  --disable-gpu
  --disable-translate
  --hide-scrollbars
  --metrics-recording-only
  --mute-audio
  --no-first-run
].tap do |options|
  options << "--headless" if CHROME_HEADLESS
end.freeze

# Fallback to local chrome
CHROME_DRIVER_OPTIONS =
  if remote_chrome
    {
      browser: :remote,
      url: REMOTE_SELENIUM_URL,
      desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: {
          args: CHROME_OPTIONS
        }
      )
    }
  else
    $stdout.puts "⚠️  Make sure you have Chrome installed in your system or " \
                 "launch it via Docker by running: `docker-compose up selenium`"
    {
      browser: :chrome,
      options: Selenium::WebDriver::Chrome::Options.new(
        args: CHROME_OPTIONS
      )
    }
  end

# Register custom driver to support uploading
# files from other containers (`file_detector` option, for example)
Capybara.register_driver :remote_selenium do |app|
  Capybara::Selenium::Driver.new(
    app,
    CHROME_DRIVER_OPTIONS
  ).tap do |driver|
    # Enable slomo mode
    driver.browser.send(:bridge).singleton_class.prepend(SlomoBridge) unless CHROME_HEADLESS

    # File detector is only available for remote driver
    next unless CHROME_DRIVER_OPTIONS.fetch(:browser) == :remote

    driver.browser.file_detector = lambda do |args|
      str = args.first.to_s
      str if File.exist?(str)
    end
  end
end

Capybara.javascript_driver = Capybara.default_driver = :remote_selenium
