require "active_record/connection_adapters/postgresql_adapter"

module ActiveRecord
  module ConnectionHandling # :nodoc:
    def pglite_adapter_class
      ConnectionAdapters::PgliteAdapter
    end

    def pglite_connection(config)
      pglite_adapter_class.new(config)
    end
  end

  module ConnectionAdapters
    class PgliteAdapter < SQLite3Adapter
      # MUST be defined somewhere
      include Pglite::ActiveRecord
    end
  end
end
