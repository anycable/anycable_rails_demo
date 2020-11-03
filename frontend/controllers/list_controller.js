import { Controller } from "stimulus";
import { createChannel } from "../utils/cable";
import { isPreview as isTurboPreview } from '../utils/turbo';
import CableReady from 'cable_ready';

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
}
