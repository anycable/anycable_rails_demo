import { createCable } from "@anycable/web";
import { ProtobufEncoder } from "@anycable/protobuf-encoder";

let consumer = createCable({
  logLevel: "debug",
  protocol: "actioncable-v1-protobuf",
  encoder: new ProtobufEncoder(),
});

export default consumer;
