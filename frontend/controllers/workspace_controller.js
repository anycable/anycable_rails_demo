import { Controller } from "@hotwired/stimulus";
import { createCable } from "../utils/cable";
import { isPreview as isTurboPreview } from "../utils/turbo";

export default class extends Controller {
  static targets = ["lists", "form"];

  connect() {
    if (isTurboPreview()) return;

    const stream = this.data.get("stream");

    const cable = createCable();

    this.channel = cable.streamFromSigned(stream);
    this.channel.on("message", (data) => this.handleUpdate(data));
    this.channel.on("connect", () =>
      this.element.setAttribute("connected", "")
    );
    this.channel.on("disconnect", () =>
      this.element.removeAttribute("connected")
    );
  }

  disconnect() {
    if (this.channel) {
      this.channel.disconnect();
      delete this.channel;
    }
  }

  handleUpdate(data) {
    if (data.type == "deletedList") {
      this.listsTarget.querySelector(`#list_${data.id}`).remove();
    } else if (data.type == "newList") {
      if (!document.getElementById(`list_${data.id}`)) {
        this.formTarget.insertAdjacentHTML("beforebegin", data.html);
      }
    }
  }
}
