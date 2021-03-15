import { cable } from "@hotwired/turbo-rails";

export async function createCable(){
  return cable.getConsumer();
}

export async function createChannel(...args) {
  const consumer = await createCable();
  return consumer.subscriptions.create(...args);
};
