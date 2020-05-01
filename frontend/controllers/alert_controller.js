import { Controller } from "stimulus";

const DEFAULT_DELAY = 2000;

export default class extends Controller {
  connect() {
    const delay = (this.data.get("delay") | 0) || DEFAULT_DELAY;
    setTimeout(() => { this.destroy() }, delay);
  }

  destroy() {
    this.element.remove();
  }
}
