import { createConsumer } from "@rails/actioncable";

let consumer;

export const createCable = () => {
  if (!consumer) {
    consumer = createConsumer();
  }

  return consumer;
}

export const createChannel = (...args) => {
  const consumer = createCable();
  return consumer.subscriptions.create(...args);
};
