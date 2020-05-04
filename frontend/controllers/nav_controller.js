import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["menu"];

  toggleMenu() {
    if (this.menuTarget.classList.contains("hidden")) {
      this.menuTarget.classList.remove("hidden");
    } else {
      this.menuTarget.classList.add("hidden");
    }
  }
}
