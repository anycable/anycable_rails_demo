import { Controller } from "stimulus";
import Cookies from "js-cookie";

const PREFIX = "any_banner_";
// Allow hiding all banners by setting a cookie
// (we use it only in tests for now)
const COOKIE = "show_banners";

export default class extends Controller {
  initialize() {
    this.bannerId = `${PREFIX}_${this.data.get("id")}`;
    this.hiddenByCookie = Cookies.get(COOKIE) == "N";
  }

  connect() {
    if (this.hiddenByCookie || localStorage.getItem(this.bannerId)) {
      this.hide();
    }
  }

  close() {
    localStorage.setItem(this.bannerId, "y");
    this.hide();
  }

  hide() {
    this.element.classList.add("hidden");
  }
}
