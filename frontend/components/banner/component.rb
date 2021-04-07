# frozen_string_literal: true

class Banner::Component < ApplicationViewComponent
  option :id

  def render?
    content.present?
  end
end
