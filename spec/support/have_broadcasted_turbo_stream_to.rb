# frozen_string_literal: true

module Turbo::HaveBroadcastedToTurboMatcher
  include Turbo::Streams::StreamName

  def have_broadcasted_turbo_stream_to(*streamables, action:, target:)
    target = target.respond_to?(:to_key) ? ActionView::RecordIdentifier.dom_id(target) : target
    have_broadcasted_to(stream_name_from(streamables))
      .with(a_string_matching(%(turbo-stream action="#{action}" target="#{target}")))
  end
end

RSpec.configure do |config|
  config.include Turbo::HaveBroadcastedToTurboMatcher
end
