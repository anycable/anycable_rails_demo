# frozen_string_literal: true

module Iodine
  module ActionCable
    class Middleware
      attr_reader :server

      delegate :logger, to: :server

      def initialize(server = ::ActionCable.server)
        @server = server
      end

      def call(env)
        if env["rack.upgrade?"] == :websocket &&
            allow_request_origin?(env)
          (subprotocol = select_protocol(env))

          env["rack.upgrade"] = Socket.new(server, env, protocol: subprotocol)
          logger.debug "[Iodine] upgrading to WebSocket [#(subprotocol)]"
          [101, {"Sec-Websocket-Protocol" => subprotocol}, []]
        else
          [404, {}, ["Not Found"]]
        end
      end

      private

      # TODO: Shouldn't this be moved to ActionCable::Server::Base?
      def allow_request_origin?(env)
        return true if server.config.disable_request_forgery_protection

        proto = ::Rack::Request.new(env).ssl? ? "https" : "http"
        if server.config.allow_same_origin_as_host && env["HTTP_ORIGIN"] == "#{proto}://#{env["HTTP_HOST"]}"
          true
        elsif Array(server.config.allowed_request_origins).any? { |allowed_origin| allowed_origin === env["HTTP_ORIGIN"] }
          true
        else
          logger.error("Request origin not allowed: #{env["HTTP_ORIGIN"]}")
          false
        end
      end

      def select_protocol(env)
        supported_protocols = ::ActionCable::INTERNAL[:protocols]
        request_protocols = env["HTTP_SEC_WEBSOCKET_PROTOCOL"]
        if !request_protocols
          logger.error("No Sec-WebSocket-Protocol provided")
          return
        end

        request_protocols = request_protocols.split(/,\s?/) if request_protocols.is_a?(String)
        subprotocol = request_protocols.detect { _1.in?(supported_protocols) }

        logger.error("Unsupported protocol: #{request_protocols}") unless subprotocol
        subprotocol
      end
    end

    # Socket wraps Iodine client and provides ActionCable::Server::_Socket interface
    class Socket
      private attr_reader :server, :coder, :connection, :client

      delegate :worker_pool, to: :server

      def initialize(server, env, protocol: nil, coder: ActiveSupport::JSON)
        @server = server
        @coder = coder
        @env = env
        @logger = server.new_tagged_logger { request }
        @protocol = protocol
        @connection = server.config.connection_class.call.new(server, self)

        # Underlying Iodine client is set on connection open
        @client = nil
      end

      #== Iodine callbacks ==
      def on_open(conn)
        logger.debug "[Iodine] connection opened"

        @client = conn
        connection.handle_open

        server.setup_heartbeat_timer
        server.add_connection(connection)
      end

      def on_message(_conn, msg)
        logger.debug "[Iodine] incoming message: #{msg}"
        connection.handle_incoming(coder.decode(msg))
      end

      def on_close(conn)
        logger.debug "[Iodine] connection closed"
        server.remove_connection(connection)
        connection.handle_close
      end

      def on_shutdown(conn)
        conn.write(
          coder.encode({
            type: :shutdown,
            reason: ::ActionCable::INTERNAL[:disconnect_reasons][:server_restart]
          })
        )
      end

      #== ActionCable socket interface ==
      attr_reader :env, :logger, :protocol

      def request
        # Copied from ActionCable::Server::Socket#request
        @request ||= begin
          environment = Rails.application.env_config.merge(env) if defined?(Rails.application) && Rails.application
          ActionDispatch::Request.new(environment || env)
        end
      end

      def transmit(data) = client&.write(coder.encode(data))

      def close = client&.close

      def perform_work(receiver, method_name, *args)
        worker_pool.async_invoke(receiver, method_name, *args, connection: self)
      end
    end
  end
end
