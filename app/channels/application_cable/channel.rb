# frozen_string_literal: true

module ApplicationCable
  class Channel < ActionCable::Channel::Base
    # We disabled anycable-rails, since it's not yet compatible with new Action Cable design
    unless respond_to?(:state_attr_accessor)
      def self.state_attr_accessor(...) = attr_accessor(...)
    end

    def html(partial, **locals)
      ApplicationController.render(partial:, locals:)
    end
  end
end
