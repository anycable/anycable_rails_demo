import { Application } from "stimulus";
import { definitionsFromContext } from "stimulus/webpack-helpers";

const application = Application.start();
const pathToModule = import.meta.globEager('./**/*_controller.js');

function context(key) {
  return pathToModule[key];
}

context.keys = () => Object.keys(pathToModule);

application.load(definitionsFromContext(context));
