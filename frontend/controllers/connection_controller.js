import { Controller } from "@hotwired/stimulus";
import { createCable } from "../utils/cable";
import { isPreview as isTurboPreview } from "../utils/turbo";

export default class extends Controller {
  static targets = ["toggle", "icon"];

  initialize() {
    this.handleOpen = this.handleOpen.bind(this);
    this.handleClose = this.handleClose.bind(this);
  }

  connect() {
    if (isTurboPreview()) return;

    this.cable = createCable().cable;

    this.unbind = [];

    this.unbind.push(this.cable.on("connect", this.handleOpen));
    this.unbind.push(this.cable.on("disconnect", this.handleClose));
    this.unbind.push(this.cable.on("close", this.handleClose));

    if (this.cable.state !== "connected") this.handleClose();
  }

  connectCable() {
    if (this.cable.state !== "closed") return;

    this.cable.connect();
  }

  disconnectCable() {
    if (this.cable.state !== "connected") return;

    this.cable.disconnect();
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
