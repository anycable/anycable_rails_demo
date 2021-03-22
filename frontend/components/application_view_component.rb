# frozen_string_literal: true

class ApplicationViewComponent < ViewComponent::Base
  include ApplicationHelper

  attr_reader :virtual_path

  def initialize(*)
    # define @virtual_path for I18n.t shortcuts to work
    @virtual_path = [
      "components",
      self.class.name.sub("::Component", "").underscore.split("/")
    ].join(".")
  end

  private

  def component_name
    @component_name ||= self.class.name.sub("::Component", "").underscore.split("/").join("--")
  end

  def class_for(name)
    "c-#{component_name}-#{name}"
  end
end
