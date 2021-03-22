# frozen_string_literal: true

ActiveSupport.on_load(:view_component) do
  Rails.application.config.to_prepare do
    ViewComponentsController.class_eval do
      include Authenticated
    end
  end

  ViewComponent::Preview.singleton_class.prepend(Module.new do
    attr_accessor :abstract_class
    alias abstract_class? abstract_class

    PREVIEW_GLOB = "**/preview.rb"

    def all
      super.reject(&:abstract_class?)
    end

    def load_previews
      Array(preview_paths).each do |preview_path|
        Dir["#{preview_path}/#{PREVIEW_GLOB}"].sort.each { |file| require_dependency file }
      end
    end

    def preview_name
      name.chomp("::Preview").underscore
    end
  end)
end
