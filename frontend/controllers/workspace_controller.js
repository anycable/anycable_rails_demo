import { Controller } from "stimulus";
import { useMutation } from "stimulus-use";

export default class extends Controller {
  static targets = ["lists", "newForm"];

  connect() {
    [this.observeLists, this.unobserveLists] = useMutation(this, { element: this.listsTarget, childList: true });
  }

  mutate(entries) {
    // There should be only one entry in case of adding a new list via streams
    const entry = entries[0];

    if (!entry.addedNodes.length) return;

    this.unobserveLists();
    this.listsTarget.append(this.newFormTarget);
    this.observeLists();
  }
}
