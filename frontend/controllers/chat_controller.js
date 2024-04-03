import { Controller } from "@hotwired/stimulus";
import { createCable } from "../utils/cable";
import { currentUser } from "../utils/current_user";
import { isPreview as isTurboPreview } from "../utils/turbo";

export default class extends Controller {
  static targets = ["input", "messages", "placeholder"];

  connect() {
    if (isTurboPreview()) return;

    const id = this.data.get("id");
    const cable = createCable();

    this.channel = cable.subscribeTo("ChatChannel", { id });
    this.channel.on("message", (data) => this.handleMessage(data));
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

  handleMessage(data) {
    if (data.action == "newMessage") {
      this.hidePlaceholder();
      const mine = currentUser().id == data.author_id;
      this.appendMessage(data.html, mine);
    }
  }

  hidePlaceholder() {
    if (this.placeholderTarget.classList.contains("hidden")) return;

    this.placeholderTarget.classList.add("hidden");
  }

  appendMessage(html, mine) {
    this.messagesTarget.insertAdjacentHTML("beforeend", html);
    this.messagesTarget.lastElementChild.classList.add(
      mine ? "mine" : "theirs"
    );

    if (mine) {
      const authorElement = this.messagesTarget.lastElementChild.querySelector(
        '[data-role="author"]'
      );
      if (authorElement) authorElement.innerText = "You";
    }

    this.element.scrollTop = this.element.scrollHeight;
  }

  send(e) {
    e.preventDefault();
    const message = this.inputTarget.value.trim();
    this.inputTarget.value = "";

    if (!message) return;

    this.channel.perform("speak", { message });
  }
}
