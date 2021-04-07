# frozen_string_literal: true

class FlashAlert::Component < ApplicationViewComponent
  option :type, default: proc { "notice" }
  option :body, optional: true

  TYPE_TO_CLASS = {
    "notice" => "border-teal-500",
    "alert" => "border-red"
  }.freeze

  def render?
    body.present?
  end

  def container_class
    TYPE_TO_CLASS.fetch(type) { raise "Unknown alert type: #{type} " }
  end
end
