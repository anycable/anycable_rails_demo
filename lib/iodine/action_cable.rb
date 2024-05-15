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
      # This is a custom _Server interface to support Iodine native pub/sub
      class ServerInterface < Data.define(:pubsub, :executor, :config)
      end

      # This is a _PubSub interface implementation that uses
      # Iodine client to subscribe to channels.
      # For that, we need an instance of Iodine::Connection to call #subscribe/#unsubscribe on.
      class PubSubInterface < Data.define(:socket)
        delegate :client, to: :socket, allow_nil: true

        def subscribe(channel, handler, on_success = nil)
          return unless client

          # NOTE: Iodine doesn't allow having different handlers for the same channel name,
          # so, having multiple channels listening to the same stream is not possible.
          #
          # Maybe, we need to pass the identifier to subscribe/unsubscribe methods to allow
          # server implementations to distinguish between different subscriptions.
          #
          # (In Iodine's case, we can create internal, server-side, subscribers to handle original broadcast requests
          # and then forward them to the specific identifiers. SubsriberMap can be reused for that.)
          client.subscribe(to: channel, handler: proc { |_, msg| handler.call(msg) })
          on_success&.call
        end

        def unsubscribe(channel, _handler)
          client&.unsubscribe(channel)
        end
      end

      private attr_reader :server, :coder, :connection
      attr_reader :client

      delegate :worker_pool, to: :server

      def initialize(server, env, protocol: nil, coder: ActiveSupport::JSON)
        @server = server
        @coder = coder
        @env = env
        @logger = server.new_tagged_logger { request }
        @protocol = protocol

        # Pick the server interface for Action Cable depending on the subscription adapter
        server_interface =
          if server.config.cable&.fetch("adapter", nil).to_s == "iodine"
            pubsub = PubSubInterface.new(self)
            ServerInterface.new(pubsub, server.executor, server.config)
          else
            server
          end

        @connection = server.config.connection_class.call.new(server_interface, self)

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

# Define Action Cable subscription adapter
# Mark it is loaded to pass the `require ...` in the `#pubsub_adapter` method.
# TODO: Make it possible to provide adapter class directly.
$LOADED_FEATURES << "action_cable/subscription_adapter/iodine"

module ActionCable
  module SubscriptionAdapter
    class Iodine < Base
      def broadcast(channel, payload)
        ::Iodine.publish(channel, payload)
      end
    end
  end
end
