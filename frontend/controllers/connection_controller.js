import { Controller } from "stimulus";
import cable from "../utils/cable";
import { isPreview as isTurboPreview } from '../utils/turbo';

export default class extends Controller {
  static targets = ["toggle", "icon"];

  initialize() {
    this.handleOpen = this.handleOpen.bind(this);
    this.handleClose = this.handleClose.bind(this);
  }

  connect() {
    if (isTurboPreview()) return;

    this.unbind = [];

    this.unbind.push(cable.on("connect", this.handleOpen));
    this.unbind.push(cable.on("disconnect", this.handleClose));
    this.unbind.push(cable.on("close", this.handleClose));

    if (cable.state !== "connected") this.handleClose();
  }

  connectCable() {
    if (cable.state !== "disconnected") return;

    cable.connect();
  }

  disconnectCable() {
    if (cable.state !== "connected") return;

    cable.close();
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
    if (this.unbind) this.unbind.forEach((clbk) => clbk());
  }
}
