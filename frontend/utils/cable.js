import { createCable, fetchTokenFromHTML } from "@anycable/web";

let consumer = createCable({
  logLevel: "debug",
  tokenRefresher: fetchTokenFromHTML(),
});

export default consumer;
