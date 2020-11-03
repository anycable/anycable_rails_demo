import { Application } from "stimulus";
import { definitionsFromContext } from "stimulus/webpack-helpers";
import StimulusReflex from "stimulus_reflex";
import { createCable } from "../utils/cable";

const application = Application.start();
const context = require.context("controllers", true, /_controller\.js$/);
application.load(definitionsFromContext(context));

const consumer = createCable();
StimulusReflex.initialize(application, { consumer });
