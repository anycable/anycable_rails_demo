# frozen_string_literal: true

class ApplicationViewComponentPreview < ViewComponentContrib::Preview::Base
  self.abstract_class = true

  layout "layouts/view_components/application"
end
