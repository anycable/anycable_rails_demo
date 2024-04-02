import { Controller } from "@hotwired/stimulus";
import { createCable } from "../utils/cable";
import { currentUser } from "../utils/current_user";
import { isPreview as isTurboPreview } from "../utils/turbo";
import { debounce } from "@github/mini-throttle";

export default class extends Controller {
  static targets = ["input", "messages", "placeholder", "typings"];

  initialize() {
    // Store typing user names
    this.typings = {};
  }

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

    this.deboucedHandleInput = debounce(this.handleInput.bind(this), 300, {
      start: true,
    });
    this.inputTarget.addEventListener("input", this.deboucedHandleInput);
  }

  disconnect() {
    if (this.channel) {
      this.channel.disconnect();
      delete this.channel;
    }

    this.inputTarget.removeEventListener("input", this.deboucedHandleInput);
  }

  handleMessage(data) {
    if (data.action === "newMessage") {
      this.hidePlaceholder();
      const mine = currentUser().id == data.author_id;
      this.appendMessage(data.html, mine);
      delete this.typings[data.author_id];
      this.invalidateTypings();
    }

    if (data.action === "typing" && data.id != currentUser().id) {
      this.typings[data.id] = { name: data.name, timestamp: Date.now() };
      this.invalidateTypings();
    }
  }

  handleInput(_e) {
    const message = this.inputTarget.value.trim();
    if (!message) return;

    const name = currentUser().name;
    if (!name) return;

    const id = currentUser().id;

    if (!this.channel) return;

    this.channel.whisper({ action: "typing", name, id });
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

  invalidateTypings() {
    let names = [];
    for (const id in this.typings) {
      const typing = this.typings[id];
      if (Date.now() - typing.timestamp > 3000) {
        delete this.typings[id];
      } else {
        names.push(typing.name);
      }
    }

    if (names.length === 0) {
      this.typingsTarget.innerText = "";
    } else if (names.length === 1) {
      this.typingsTarget.innerText = `${names[0]} is typing...`;
    } else {
      this.typingsTarget.innerText = `${names.length} persons are typing...`;
    }

    setTimeout(() => this.invalidateTypings(), 1000);
  }
}
