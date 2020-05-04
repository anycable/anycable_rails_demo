import { Controller } from "stimulus";
import { DELETE } from "../utils/api";

export default class extends Controller {
  static targets = ["items"];

  connect() {
  }

  disconnect() {
  }

  deleteItem(e) {
    const url = e.currentTarget.dataset["url"];
    if (!url) {
      console.error("URL not set for button", e.currentTarget);
      return;
    }

    DELETE(url).then((data) => {
      this.removeItem(data.deletedId);
    });
  }

  removeItem(id) {
    const item = this.itemsTarget.querySelector(`#item_${id}`);
    if (!item) {
      console.error("Failed to find list item with id:", id);
      return;
    }

    item.remove();
  }
}
