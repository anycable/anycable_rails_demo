import { Controller } from "stimulus";
import { rememberWorkspace } from "../../utils/workspaces";

export default class extends Controller {
  connect() {
    rememberWorkspace(this.data.get("url"), this.data.get("name"));
  }
}
