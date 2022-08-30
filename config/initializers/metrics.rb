# frozen_string_literal: true

# To collect metrics from all processes
Prometheus::Client.config.data_store = Prometheus::Client::DataStores::DirectFileStore.new(dir: "/tmp/prometheus_direct_file_store")

AnyCable.configure_server do
  Yabeda::Prometheus::Exporter.start_metrics_server!
end
