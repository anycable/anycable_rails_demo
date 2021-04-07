# frozen_string_literal: true

ActiveSupport.on_load(:view_component) do
  Rails.application.config.to_prepare do
    ViewComponentsController.class_eval do
      include Authenticated
    end
  end

  ViewComponent::Preview.extend ViewComponentContrib::Preview::Sidecarable
  ViewComponent::Preview.extend ViewComponentContrib::Preview::Abstract
end
