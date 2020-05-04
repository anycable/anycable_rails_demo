import { Controller } from "stimulus";
import { createCable } from "../utils/cable";
import { isPreview as isTurbolinksPreview } from '../utils/turbolinks';

export default class extends Controller {
  static targets = ["toggle", "icon"];

  initialize() {
    this.handleOpen = this.handleOpen.bind(this);
    this.handleClose = this.handleClose.bind(this);
  }

  connect() {
    if (isTurbolinksPreview()) return;

    this.connection = createCable().connection;

    if (!this.connection.webSocket) {
      // Action Cable initializes a WebSocket connection lazily,
      // let's "append" the open method to know when a socket becomes available
      const origOpen = this.connection.open.bind(this.connection);
      this.connection.open = () => {
        origOpen.call();
        this.monitor(this.connection.webSocket);
      }
    } else if (this.connection.isActive()) {
      return this.handleOpen();
    }

    this.handleClose();
  }

  connectCable() {
    if (!this.connection.webSocket) return this.connection.open();

    this.connection.monitor.reconnectAttempts = 2;
    this.connection.monitor.start();
    this.connection.open();
  }

  disconnectCable() {
    if (!this.connection.isActive()) return;

    this.connection.monitor.stop();
    this.connection.close();
  }

  monitor(socket) {
    if (this.socket) {
      this.socket.removeEventListener("open", this.handleOpen);
      this.socket.removeEventListener("close", this.handleClose);
    }

    this.socket = socket;
    this.socket.addEventListener("open", this.handleOpen);
    this.socket.addEventListener("close", this.handleClose);
  }

  toggleState(e) {
    if (this.toggleTarget.checked) {
      this.connectCable();
    } else {
      this.disconnectCable();
    }
  }

  handleOpen(e) {
    this.toggleTarget.checked = true;
    this.iconTarget.classList.add("active");
  }

  handleClose(e) {
    this.toggleTarget.checked = false;
    this.iconTarget.classList.remove("active");
  }

  disconnect() {
    this.active = false;
  }
}
