# frozen_string_literal: true

class GraphqlChannel < ApplicationCable::Channel
  def execute(data)
    result =
      ApplicationSchema.execute(
        query: data["query"],
        context: context,
        variables: Hash(data["variables"]),
        operation_name: data["operationName"]
      )

    transmit({
      result: result.to_h,
      more: result.subscription?
    })
  end

  def unsubscribed
    channel_id = params.fetch("channelId")
    ApplicationSchema.subscriptions.delete_channel_subscriptions(channel_id)
  end

  private

  def context
    {
      channel: self
    }
  end
end
