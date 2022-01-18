# frozen_string_literal: true

require "yabeda/prometheus/mmap"

AnyCable.configure_server do
  Yabeda::Prometheus::Exporter.start_metrics_server!
end
