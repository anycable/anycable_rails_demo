import { Controller } from "@hotwired/stimulus";
import { createCable } from "../utils/cable";
import { isPreview as isTurboPreview } from "../utils/turbo";

export default class extends Controller {
  static targets = ["lists", "form"];

  connect() {
    if (isTurboPreview()) return;

    const cable = createCable();
    const stream = this.data.get("stream");

    this.channel = cable.streamFrom(stream);
    this.channel.on("message", (data) => {
      this.handleUpdate(data);
    });
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
      if (!document.getElementById(data.id)) {
        this.formTarget.insertAdjacentHTML("beforebegin", data.html);
      }
    }
  }
}
