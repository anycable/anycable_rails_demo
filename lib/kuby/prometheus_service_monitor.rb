# frozen_string_literal: true

module Kuby::PrometheusOperatorDSLV1
  class NamespaceSelector < ::KubeDSL::DSLObject
    value_field :match_names

    validates :match_names, array: {kind_of: :string}, presence: true

    def serialize
      {}.tap do |result|
        result[:matchNames] = Array(match_names)
      end
    end

    def kind_sym
      :namespace_selector
    end
  end

  class ServiceMonitorSpec < ::KubeDSL::DSLObject
    object_field(:selector) { KubeDSL::DSL::Meta::V1::LabelSelector.new }
    object_field(:namespace_selector) { NamespaceSelector.new }
    array_field(:endpoint) { KubeDSL::DSL::V1::ServicePort.new }

    validates :selector, object: {kind_of: KubeDSL::DSL::Meta::V1::LabelSelector}
    validates :namespace_selector, object: {kind_of: NamespaceSelector}
    validates :endpoints, array: {kind_of: KubeDSL::DSL::V1::ServicePort}, presence: false

    def serialize
      {}.tap do |result|
        result[:selector] = selector.serialize
        result[:namespaceSelector] = namespace_selector.serialize
        result[:endpoints] = endpoints.map(&:serialize)
      end
    end

    def kind_sym
      :service_monitor_spec
    end
  end

  class ServiceMonitor < ::KubeDSL::DSLObject
    object_field(:spec) { ServiceMonitorSpec.new }
    value_field :api_version
    object_field(:metadata) { KubeDSL::DSL::Meta::V1::ObjectMeta.new }

    validates :spec, object: {kind_of: ServiceMonitorSpec}
    validates :api_version, field: {format: :string}, presence: false
    validates :metadata, object: {kind_of: KubeDSL::DSL::Meta::V1::ObjectMeta}

    def serialize
      {}.tap do |result|
        result[:kind] = "ServiceMonitor"
        result[:spec] = spec.serialize
        result[:apiVersion] = "monitoring.coreos.com/v1"
        result[:metadata] = metadata.serialize
      end
    end

    def kind_sym
      :service_monitor
    end
  end
end

module Kuby
  class PrometheusPlugin < ::Kuby::Plugin
    extend ::KubeDSL::ValueFields

    attr_reader :monitors
    alias_method :resources, :monitors

    def after_initialize
      @monitors = []
    end

    def configure(&block)
      instance_eval(&block) if block
    end

    def monitor(&block)
      monitors << Kuby::PrometheusOperatorDSLV1::ServiceMonitor.new(&block)
    end
  end
end

Kuby.register_plugin(:prometheus_service_monitor, Kuby::PrometheusPlugin)
