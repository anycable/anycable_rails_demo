import { Controller } from "stimulus";
import { createChannel } from "../utils/cable";
import { isPreview as isTurboPreview } from '../utils/turbo';

export default class extends Controller {
  static targets = ["lists", "form"];

  async connect() {
    if (isTurboPreview()) return;

    const channel = "WorkspaceChannel";
    const id = this.data.get("id");

    this.channel = await createChannel(
      {channel, id},
      {
        received: (data) => {
          this.handleUpdate(data);
        },
      }
    );
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
