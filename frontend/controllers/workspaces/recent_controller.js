import { Controller } from "@hotwired/stimulus";
import { visitedWorkspaces } from "../../utils/workspaces";
import { isPreview as isTurboPreview } from "../../utils/turbo";

export default class extends Controller {
  connect() {
    if (isTurboPreview()) return;

    // remove stale data first
    this.element.innerHTML = "";

    let visited = visitedWorkspaces();
    if (visited) {
      this.addWorkspaces(visited);
    } else {
      this.addPlaceholder();
    }
  }

  addPlaceholder() {
    const el = document.createElement("span");
    el.textContent = "None";
    this.element.appendChild(el);
  }

  addWorkspaces(list) {
    const ul = document.createElement("ul");

    list.forEach(({ name, url }) => {
      const li = document.createElement("li");
      const a = document.createElement("a");
      a.href = url;
      a.textContent = name;
      li.appendChild(a);
      ul.appendChild(li);
    });

    this.element.appendChild(ul);
  }
}
