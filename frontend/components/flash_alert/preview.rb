# frozen_string_literal: true

class FlashAlert::Preview < ApplicationViewComponentPreview
  def notice
    render_component FlashAlert::Component.new(type: "notice", body: "Your notice has been created")
  end

  def alert
    render_component FlashAlert::Component.new(type: "alert", body: "Your alert has been created")
  end
end
