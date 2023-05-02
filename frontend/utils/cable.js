import { createConsumer } from "@anycable/web";

let consumer;

export const createCable = () => {
  if (!consumer) {
    consumer = createConsumer({
      protocol: "actioncable-v1-ext-json",
    });
  }

  return consumer;
};

export const createChannel = (...args) => {
  const consumer = createCable();
  return consumer.subscriptions.create(...args);
};
