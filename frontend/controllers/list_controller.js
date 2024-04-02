import { Controller } from "@hotwired/stimulus";
import { createCable } from "../utils/cable";
import { isPreview as isTurboPreview } from "../utils/turbo";
import { DELETE, PATCH } from "../utils/api";

export default class extends Controller {
  static targets = ["items"];

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
    if (data.type == "deleted") {
      this.removeItem(data.id);
    } else if (data.type == "updated") {
      this.updateCompleted(data.id, data.completed);
    } else if (data.type == "created") {
      if (!document.getElementById(data.id)) {
        this.itemsTarget.insertAdjacentHTML("beforeend", data.html);
      }
    }
  }

  deleteItem(e) {
    const url = e.currentTarget.dataset["url"];
    if (!url) {
      console.error("URL not set for button", e.currentTarget);
      return;
    }

    DELETE(url).then((data) => {
      this.removeItem(data.deletedId);
    });
  }

  toggleCompleted(e) {
    const checkbox = e.currentTarget;
    const url = checkbox.dataset["url"];

    if (!url) {
      console.error("URL not set for button", e.currentTarget);
      return;
    }

    PATCH(url, { item: { completed: checkbox.checked } }).then((data) => {
      this.updateCompleted(data.id, data.completed);
    });
  }

  removeItem(id) {
    const item = this.itemsTarget.querySelector(`#item_${id}`);
    if (!item) {
      console.error("Failed to find list item with id:", id);
      return;
    }

    item.remove();
  }

  updateCompleted(id, completed) {
    const item = this.itemsTarget.querySelector(`#item_${id}`);
    if (!item) {
      console.error("Failed to find list item with id:", id);
      return;
    }

    const checkbox = item.querySelector("input[type=checkbox]");

    checkbox.checked = completed;
    if (completed) {
      item.classList.add("checked");
    } else if (item.classList.contains("checked")) {
      item.classList.remove("checked");
    }
  }
}
