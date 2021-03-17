import { Controller } from "stimulus";
import { currentUser } from "../utils/current_user";
import { useMutation } from "stimulus-use";

export default class extends Controller {
  static targets = ["messages", "placeholder"];

  connect() {
    [this.observeMessages, this.unobserveMessages] = useMutation(this, { element: this.messagesTarget, childList: true });
  }

  mutate(entries) {
    const entry = entries[0];

    if (!entry.addedNodes.length) return;

    this.unobserveMessages();
    this.hidePlaceholder();
    this.observeMessages();

    // Scroll to the bottom
    this.element.scrollTop = this.element.scrollHeight;
  }

  hidePlaceholder() {
    if(this.placeholderTarget.classList.contains("hidden")) return;

    this.placeholderTarget.classList.add("hidden");
  }
}
