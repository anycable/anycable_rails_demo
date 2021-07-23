import { Controller } from "stimulus";
import cable from "../utils/cable";
import { Channel } from "@anycable/web";
import { isPreview as isTurboPreview } from '../utils/turbo';
import { DELETE, PATCH } from "../utils/api";

class ListChannel extends Channel {
  static identifier = "ListChannel";
}

export default class extends Controller {
  static targets = ["items"];

  connect() {
    if (isTurboPreview()) return;

    const id = this.data.get("id");
    const workspace = this.data.get("workspace");

    this.channel = new ListChannel({ id, workspace });
    this.channel.on("message", (data) => this.handleUpdate(data));

    cable.subscribe(this.channel);
  }

  disconnect() {
    if (this.channel) {
      this.channel.unsubscribe();
      delete this.channel;
    }
  }

  handleUpdate(data) {
    if (data.type == "deleted") {
      this.removeItem(data.id);
    } else if (data.type == "updated") {
      this.updateCompleted(data.id, data.completed);
    } else if (data.type == "created") {
      this.itemsTarget.insertAdjacentHTML("beforeend", data.html);
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

    PATCH(url, {item: {completed: checkbox.checked}}).then((data) => {
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
    if(completed) {
      item.classList.add("checked");
    } else if (item.classList.contains("checked")) {
      item.classList.remove("checked");
    }
  }
}
