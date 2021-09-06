import { currentUser } from "../utils/current_user";

export class ChatMessageElement extends HTMLElement {
  connectedCallback() {
    const mine = currentUser().id == this.dataset.authorId;

    this.classList.add(mine ? "mine" : "theirs");

    const authorElement = this.querySelector('[data-role="author"]');

    if (authorElement && mine) authorElement.innerText = "You";
  }
}

customElements.define("any-chat-message", ChatMessageElement);
