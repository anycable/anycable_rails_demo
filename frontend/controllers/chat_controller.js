import { Controller } from "stimulus";
import cable from "../utils/cable";
import { Channel } from "@anycable/web";
import { currentUser } from "../utils/current_user";
import { isPreview as isTurboPreview } from '../utils/turbo';

class ChatChannel extends Channel {
  static identifier = "ChatChannel";

  speak(message) {
    this.perform("speak", { message });
  }
}

export default class extends Controller {
  static targets = ["input", "messages", "placeholder"];

  connect() {
    if (isTurboPreview()) return;

    const id = this.data.get("id");

    this.channel = new ChatChannel({ id });
    this.channel.on("message", (data) => this.handleMessage(data));

    cable.subscribe(this.channel);
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

    this.channel.speak(message);
  }
}
