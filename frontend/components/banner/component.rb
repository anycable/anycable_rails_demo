# frozen_string_literal: true

class Banner::Component < ApplicationViewComponent
  attr_reader :id

  def initialize(id:)
    super
    @id = id
  end

  def render?
    content.present?
  end
end
