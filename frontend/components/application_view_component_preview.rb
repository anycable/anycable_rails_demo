# frozen_string_literal: true

class ApplicationViewComponentPreview < ViewComponent::Preview
  self.abstract_class = true

  DEFAULT_TEMPLATE = "layouts/view_components/preview"

  class << self
    attr_accessor :default_locals

    def preview_example_template_path(*)
      super
    rescue ViewComponent::PreviewTemplateError
      preview_template_name = File.join(preview_name, "preview")

      default_component_template = preview_paths.first.join("#{preview_template_name}.html.erb")

      default_component_template.file? ? preview_template_name : DEFAULT_TEMPLATE
    end

    def render_args(*)
      super.tap do |res|
        res[:layout] ||= "layouts/view_components/application"
        res[:locals] ||= {}
        res[:locals].reverse_merge!(default_locals) if default_locals
        res[:locals][:component] = name.sub(/Preview$/, "").safe_constantize&.new unless res[:locals].key?(:component)
        res[:locals][:container_class] ||= ""
      end
    end
  end

  # Shortcut for render_with_template(locals: ...)
  def render_with_locals(**locals)
    render_with_template(locals: locals)
  end

  # Even shorter :)
  def render_component(component)
    render_with_locals(component: component)
  end
end
