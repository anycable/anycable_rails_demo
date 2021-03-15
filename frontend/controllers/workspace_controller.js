import { Controller } from "stimulus";
import { useTargetMutation } from "stimulus-use";

export default class extends Controller {
  static targets = ["lists", "newForm"];

  connect() {
    [this.observeLists, this.unobserveLists] = useTargetMutation(this, { targets: ["lists"] });
  }

  listsTargetChanged() {
    this.unobserveLists();
    this.listsTarget.append(this.newFormTarget);
    this.observeLists();
  }
}
