import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    if (localStorage.getItem(this.data.get("id"))) {
      this.hide();
    }
  }

  close() {
    localStorage.setItem(this.data.get("id"), "y");
    this.hide();
  }

  hide() {
    this.element.classList.add("hidden");
  }
}
