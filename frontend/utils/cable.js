import { createCable as create } from "@anycable/web";

let consumer;

export const createCable = () => {
  if (!consumer) {
    consumer = create({
      logLevel: "debug",
      protocol: "actioncable-v1-ext-json",
    });
  }

  return consumer;
};
