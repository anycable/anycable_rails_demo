# frozen_string_literal: true

class FlashAlert::Component < ApplicationViewComponent
  attr_reader :type, :body

  TYPE_TO_CLASS = {
    "notice" => "border-teal-500",
    "alert" => "border-red"
  }.freeze

  def initialize(type: "notice", body: nil)
    super
    @type = type
    @body = body
  end

  def render?
    body.present?
  end

  def container_class
    TYPE_TO_CLASS.fetch(type) { raise "Unknown alert type: #{type} " }
  end
end
