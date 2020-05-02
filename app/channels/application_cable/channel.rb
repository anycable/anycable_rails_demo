# frozen_string_literal: true

module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def html(template, **locals)
      ApplicationController.render(
        partial: template,
        locals: locals
      )
    end
  end
end
