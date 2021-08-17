import { check, sleep, fail } from "k6";
import cable from "k6/x/cable";
import { randomIntBetween } from "https://jslib.k6.io/k6-utils/1.1.0/index.js";

import { Trend } from "k6/metrics";

let rttTrend = new Trend("rtt", true);

let userId = `100${__VU}`;
let userName = `Kay${userId}`;

const URL = __ENV.CABLE_URL || "ws://localhost:8080/cable";
const WORKSPACE = __ENV.WORKSPACE || "demo";

// The number of messages each VU sends during an iteration
const MESSAGES_NUM = parseInt(__ENV.NUM || "5");
// Max VUs during the peak
const MAX = parseInt(__ENV.MAX || "20");
// Total test duration
const TIME = parseInt(__ENV.TIME || "120");

export let options = {
  thresholds: {
    checks: ["rate>0.9"],
  },
  scenarios: {
    chat: {
      executor: "ramping-vus",
      startVUs: (MAX / 10 || 1) | 0,
      stages: [
        { duration: `${TIME / 3}s`, target: (MAX / 4) | 0 },
        { duration: `${(7 * TIME) / 12}s`, target: MAX },
        { duration: `${TIME / 12}s`, target: 0 },
      ],
    },
  },
};

export default function () {
  let client = cable.connect(URL, {
    cookies: `uid=${userName}/${userId}`,
    receiveTimeoutMS: 30000,
  });

  if (
    !check(client, {
      "successful connection": (obj) => obj,
    })
  ) {
    fail("connection failed");
  }

  let channel = client.subscribe("ChatChannel", { id: WORKSPACE });

  if (
    !check(channel, {
      "successful subscription": (obj) => obj,
    })
  ) {
    fail("failed to subscribe");
  }

  for (let i = 0; i < MESSAGES_NUM; i++) {
    let startMessage = Date.now();
    channel.perform("speak", { message: `hello from ${userName}` });

    let message = channel.receive({ author_id: userId });

    if (
      !check(message, {
        "received its own message": (obj) => obj,
      })
    ) {
      fail("expected message hasn't been received");
    }

    let endMessage = Date.now();
    rttTrend.add(endMessage - startMessage);

    sleep(randomIntBetween(5, 10) / 10);
  }

  client.disconnect();
}
