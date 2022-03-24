# frozen_string_literal: true

require "action_cable/subscription_adapter/any_cable"

# Run AnyCable RPC server
RSpec.configure do |config|
  cli = nil

  config.before(:suite) do
    examples = RSpec.world.filtered_examples.values.flatten
    has_no_system_tests = examples.none? { |example| example.metadata[:type] == :system }

    next if has_no_system_tests

    require "anycable/cli"

    $stdout.puts "\n⚡️  Starting AnyCable RPC server...\n"

    cli = AnyCable::CLI.new(embedded: true)
    cli.run
  end

  config.after(:suite) do
    cli&.shutdown
  end
end
