# frozen_string_literal: true

# Capybara Thruster integration
require "childprocess"
Capybara.register_server :thruster do |app, port, host, **options|
  puma_port = port + 1

  # TODO: Figure out how to avoid sleep here
  process = ChildProcess.build("bundle", "exec", "thrust", "sleep", "100")
  process.environment["TARGET_PORT"] = puma_port.to_s
  process.environment["HTTP_PORT"] = port.to_s

  # AnyCable options
  anycable_options = {rpc_host: "http://localhost:#{puma_port}/_anycable", broadcast_adapter: "http"}
  anycable_options.merge!(options[:anycable_options]) if options[:anycable_options]
  process.environment["ANYCABLE_OPT"] = anycable_options.reduce(+"") { |acc, (k, v)| "#{acc} --#{k}=#{v}" }

  # Additional environment variables
  options.fetch(:env, {}).each { |k, v| process.environment[k.to_s] = v.to_s }

  process.io.inherit! if options.delete(:debug) == true
  process.start

  at_exit { process.stop }

  Capybara.servers[:puma].call(app, puma_port, host)
end

Capybara.server = :thruster, {debug: ENV["DEBUG"] == "1"}

# Capybara settings (not covered by Rails system tests)

# Don't wait too long in `have_xyz` matchers
Capybara.default_max_wait_time = 2

# Normalizes whitespaces when using `has_text?` and similar matchers
Capybara.default_normalize_ws = true

# Where to store artifacts (e.g. screenshots, downloaded files, etc.)
Capybara.save_path = ENV.fetch("CAPYBARA_ARTIFACTS", "./tmp/capybara")

# Use fixed server port to configure AnyCable broadcast url
Capybara.server_port = 3023

Capybara.singleton_class.prepend(Module.new do
  attr_accessor :last_used_session

  def using_session(name, &block)
    self.last_used_session = name
    super
  ensure
    self.last_used_session = nil
  end
end)
