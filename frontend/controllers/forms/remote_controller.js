import { Controller } from "stimulus";
import { DELETE, HTMLrequest } from "../../utils/api";

// A custom `remote: true` implemenation
export default class extends Controller {
  initialize() {
    this.handleSubmit = this.handleSubmit.bind(this);
    this.method = this.element.method;
    this.url = this.element.action;
  }

  connect() {
    this.element.addEventListener("submit", this.handleSubmit);
  }

  disconnect() {
    this.element.removeEventListener("submit", this.handleSubmit);
  }

  handleSubmit(e) {
    e.preventDefault();
    let req = this.method === "delete" ? DELETE(this.url) : HTMLrequest(this.url, this.method, new FormData(this.element));
    req.then( (response) => {
      eval(response);
    });
  }
}
