import { createConsumer, logger, adapters, INTERNAL } from "@rails/actioncable";
import msgpack from "@ygoe/msgpack";

let consumer;

export const createCable = () => {
  if (!consumer) {
    consumer = createConsumer();
    Object.assign(consumer.connection, connectionExtension);
    Object.assign(consumer.connection.events, connectionEventsExtension);
  }

  return consumer;
}

export const createChannel = (...args) => {
  const consumer = createCable();
  return consumer.subscriptions.create(...args);
};

// Msgpack support
// Patches this file: https://github.com/rails/rails/blob/main/actioncable/app/javascript/action_cable/connection.js

// Replace JSON protocol with msgpack
const supportedProtocols = [
  "actioncable-v1-msgpack"
]

const protocols = supportedProtocols
const { message_types } = INTERNAL

const connectionExtension = {
  open() {
    if (this.isActive()) {
      logger.log(`Attempted to open WebSocket, but existing socket is ${this.getState()}`)
      return false
    } else {
      logger.log(`Opening WebSocket, current state is ${this.getState()}, subprotocols: ${protocols}`)
      if (this.webSocket) { this.uninstallEventHandlers() }
      this.webSocket = new adapters.WebSocket(this.consumer.url, protocols)
      this.webSocket.binaryType = "arraybuffer"
      this.installEventHandlers()
      this.monitor.start()
      return true
    }
  },
  isProtocolSupported() {
    return supportedProtocols[0] == this.getProtocol()
  },
  send(data) {
    if (this.isOpen()) {
      const encoded = msgpack.encode(data);
      this.webSocket.send(encoded)
      return true
    } else {
      return false
    }
  }
}

// Incoming messages are handled by the connection.events.message function.
// There is no way to patch it, so, we have to copy-paste :(
const connectionEventsExtension = {
  message(event) {
    if (!this.isProtocolSupported()) { return }
    const {identifier, message, reason, reconnect, type} = msgpack.decode(new Uint8Array(event.data))
    switch (type) {
      case message_types.welcome:
        this.monitor.recordConnect()
        return this.subscriptions.reload()
      case message_types.disconnect:
        logger.log(`Disconnecting. Reason: ${reason}`)
        return this.close({allowReconnect: reconnect})
      case message_types.ping:
        return this.monitor.recordPing()
      case message_types.confirmation:
        return this.subscriptions.notify(identifier, "connected")
      case message_types.rejection:
        return this.subscriptions.reject(identifier)
      default:
        return this.subscriptions.notify(identifier, "received", message)
    }
  },
};
