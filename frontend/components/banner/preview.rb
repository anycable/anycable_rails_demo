# frozen_string_literal: true

class Banner::Preview < ApplicationViewComponentPreview
  self.default_locals = {
   container_class: "w-1/2"
  }

  def default
    render_component(nil)
  end
end
