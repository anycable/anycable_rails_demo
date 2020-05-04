import { Controller } from "stimulus";

const DEFAULT_MESSAGE = "Are you sure you want to perform this action?";

export default class extends Controller {
  connect() {
    this.handleSubmit = this.handleSubmit.bind(this);
    this.message = this.data.get("text") || DEFAULT_MESSAGE;
    this.element.addEventListener("submit", this.handleSubmit);
  }

  disconnect() {
    this.element.removeEventListener("submit", this.handleSubmit);
  }

  handleSubmit(e) {
    if (!window.confirm(this.message)) {
      e.preventDefault();
    }
  }
}
