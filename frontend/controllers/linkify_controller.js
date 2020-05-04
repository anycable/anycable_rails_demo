import { Controller } from "stimulus";
import linkifyStr from 'linkifyjs/string';

const MAX_SIZE = 25;

export default class extends Controller {
  connect() {
    if (this.linkfied) return;
    this.element.innerHTML = linkifyStr(this.element.innerText, {format: this.format});
    this.linkfied = true;
  }

  format(value, type) {
    value = value.replace(/^\w+:\/\//, "");
    if (type === "url" && value.length > MAX_SIZE) {
      value = value.slice(0, MAX_SIZE - 2) + "…";
    }
    return value;
  }
}
