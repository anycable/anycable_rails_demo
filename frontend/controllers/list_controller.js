import { Controller } from "stimulus";
import { createChannel } from "../utils/cable";
import { isPreview as isTurboPreview } from '../utils/turbo';
import CableReady from 'cable_ready';
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = ["items"];

  connect() {
    if (isTurboPreview()) return;

    const channel = "ListChannel";
    const id = this.data.get("id");
    const workspace = this.data.get("workspace");

    this.channel = createChannel(
      {channel, id, workspace},
      {
        received: (data) => {
          if (data.cableReady) CableReady.perform(data.operations);
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

  submitItemCompleted(e) {
    const checkbox = e.currentTarget;
    const form = checkbox.form;

    if (!form) {
      console.error("Form couldn't be foudn for the input", e.currentTarget);
      return;
    }

    Rails.fire(form, "submit");
  }
}
