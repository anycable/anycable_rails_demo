import { Controller } from "stimulus";
import { createChannel } from "../utils/cable";
import { currentUser } from "../utils/current_user";
import { isPreview as isTurboPreview } from '../utils/turbo';

export default class extends Controller {
  static targets = ["input", "messages", "placeholder"];

  async connect() {
    if (isTurboPreview()) return;

    const channel = "ChatChannel";
    const id = this.data.get("id");
    this.channel = await createChannel(
      {channel, id},
      {
        received: (data) => {
          this.handleMessage(data);
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

    if (mine) {
      const authorElement = this.messagesTarget.lastElementChild.querySelector('[data-role="author"]');
      if (authorElement) authorElement.innerText = "You";
    }

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
