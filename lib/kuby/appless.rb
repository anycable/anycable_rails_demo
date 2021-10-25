# frozen_string_literal: true

module Kuby
  module Kubernetes
    module Appless
      class Deployer < Kubernetes::Deployer
        def restart_rails_deployment_if_necessary() = yield
      end

      class Spec < Kubernetes::Spec
        using(Module.new do
          refine Kuby::Kubernetes::Provider do
            attr_writer :deployer
          end
        end)

        def initialize(*)
          super

          # Remove default rails_app plugin
          @plugins.delete(:rails_app)
          # Set tag to none (so we don't call docker provider)
          @tag = "none"
        end

        # Do not include globals, only plugin provided resources
        def resources
          @resources ||= Manifest.new([
            *@plugins.flat_map { |_, plugin| plugin.resources }
          ].compact)
        end

        def deploy(tag = nil)
          provider.deployer = Deployer.new(environment)
          super(tag || @tag)
        end
      end
    end
  end
end

# Add #kubernetes_appless to manage pure kubernetes resources
Kuby::Environment.include(Module.new do
  def kubernetes_appless(&block)
    @kubernetes ||= Kuby::Kubernetes::Appless::Spec.new(self)
    @kubernetes.instance_eval(&block) if block
    @kubernetes
  end
end)
