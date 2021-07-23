import { Controller } from "stimulus";
import cable from "../utils/cable";
import { Channel } from "@anycable/web";
import { isPreview as isTurboPreview } from '../utils/turbo';

class WorkspaceChannel extends Channel {
  static identifier = "WorkspaceChannel";
}

export default class extends Controller {
  static targets = ["lists", "form"];

  connect() {
    if (isTurboPreview()) return;

    const id = this.data.get("id");

    this.channel = new WorkspaceChannel({ id });
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
    if (data.type == "deletedList") {
      this.listsTarget.querySelector(`#list_${data.id}`).remove();
    } else if (data.type == "newList") {
      this.formTarget.insertAdjacentHTML("beforebegin", data.html);
    }
  }
}
