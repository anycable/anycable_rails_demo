import { Controller } from "stimulus";
import { createChannel } from "../utils/cable";
import { currentUser } from "../utils/current_user";

export default class extends Controller {
  static targets = ["input", "messages", "placeholder"];

  connect() {
    const channel = "ChatChannel";
    const id = this.data.get("id");
    this.channel = createChannel(
      {channel, id},
      {
        received: (data) => {
          this.handleMessage(data);
        },
      }
    );
  }

  disconnect() {
    this.channel.disconnect();
  }

  handleMessage(data) {
    if (data.action == "newMessage") {
      this.hidePlaceholder();
      const mine = currentUser().id == data.author_id
      this.appendMessage(data.html, mine);
    }
  }

  hidePlaceholder() {
    if(this.placeholderTarget.classList.contains("hidden")) return;

    this.placeholderTarget.classList.add("hidden");
  }

  appendMessage(html, mine) {
    this.messagesTarget.insertAdjacentHTML("beforeend", html);
    this.messagesTarget.lastElementChild.classList.add(mine ? "mine" : "theirs");
    this.element.scrollTop = this.element.scrollHeight;
  }

  send(e) {
    e.preventDefault();
    const message = this.inputTarget.value.trim();
    this.inputTarget.value = "";

    if (!message) return;

    this.channel.perform("speak", {message});
  }
}
