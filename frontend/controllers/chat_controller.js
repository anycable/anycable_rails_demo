import { Controller } from "@hotwired/stimulus";
import { createCable } from "../utils/cable";
import { currentUser } from "../utils/current_user";
import { isPreview as isTurboPreview } from "../utils/turbo";

export default class extends Controller {
  static targets = ["input", "messages", "placeholder"];

  connect() {
    if (isTurboPreview()) return;

    const cable = createCable();
    const stream = this.data.get("stream");

    this.channel = cable.streamFrom(stream);
    this.channel.on("message", (data) => {
      this.handleMessage(data);
    });
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

    const author_id = this.data.get("user");
    const name = this.data.get("name");
    const html = this.generateMessageHTML(message, name);

    const event = {
      action: "newMessage",
      html,
      author_id,
    };

    this.channel.whisper(event);
    this.appendMessage(html, true);
  }

  generateMessageHTML(body, name) {
    const template = this.element.querySelector("template");

    return template.innerHTML
      .replace("%%BODY%%", body)
      .replace("%%USER%%", name);
  }
}
