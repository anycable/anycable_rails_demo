import { Application } from "@hotwired/stimulus";
const application = Application.start();

import controllers from "./**/*_controller.js";
controllers.forEach((controller) => {
  application.register(controller.name, controller.module.default);
});
