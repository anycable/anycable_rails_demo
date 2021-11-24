# frozen_string_literal: true

require "action_cable/subscription_adapter/any_cable"

# Run AnyCable RPC server
RSpec.configure do |config|
  next if config.filter.opposite.rules[:type] == "system" || config.exclude_pattern.match?(%r{spec/system})

  require "anycable/cli"

  cli = AnyCable::CLI.new(embedded: true)
  cli.run

  config.after(:suite) do
    cli&.shutdown
  end

  config.before(:each, type: :system) do
    next if ActionCable.server.pubsub.is_a?(ActionCable::SubscriptionAdapter::AnyCable)

    @__was_pubsub_adapter__ = ActionCable.server.pubsub

    adapter = ActionCable::SubscriptionAdapter::AnyCable.new(ActionCable.server)
    ActionCable.server.instance_variable_set(:@pubsub, adapter)
  end

  config.after(:each, type: :system) do
    next unless instance_variable_defined?(:@__was_pubsub_adapter__)
    ActionCable.server.instance_variable_set(:@pubsub, @__was_pubsub_adapter__)
  end
end
