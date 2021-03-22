import "./index.css"
import { Controller as BaseController } from "stimulus";

const DEFAULT_DELAY = 2000;

export class Controller extends BaseController {
  connect() {
    const delay = (this.data.get("delay") | 0) || DEFAULT_DELAY;
    setTimeout(() => { this.destroy() }, delay);
  }

  destroy() {
    this.element.remove();
  }
}
