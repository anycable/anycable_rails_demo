import { check, sleep, fail } from "k6";
import http from "k6/http";
import cable from "k6/x/cable";
import { randomIntBetween } from "https://jslib.k6.io/k6-utils/1.1.0/index.js";

import { Trend } from "k6/metrics";

let rttTrend = new Trend("rtt", true);

let userId = `100${__VU}`;
let userName = `Kay${userId}`;

const URL = __ENV.URL || "http://localhost:3000";
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

function cableUrl(doc) {
  let el = doc.find('meta[name="action-cable-url"]');
  if (!el) return;

  return el.attr("content");
}

function turboStreamName(doc) {
  let el = doc.find("turbo-cable-stream-source");
  if (!el) return;

  return el.attr("signed-stream-name");
}

export default function () {
  // Manually set authentication cookies
  let jar = http.cookieJar();
  jar.set(URL, "uid", `${userName}/${userId}`);

  let res = http.get(URL + "/workspaces/" + WORKSPACE);

  if (
    !check(res, {
      "is status 200": (r) => r.status === 200,
    })
  ) {
    fail("couldn't open dashboard");
  }

  const html = res.html();
  const wsUrl = cableUrl(html);

  if (!wsUrl) {
    fail("couldn't find cable url on the page");
  }

  let client = cable.connect(wsUrl, {
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

  let streamName = turboStreamName(html);

  if (!streamName) {
    fail("couldn't find a turbo stream element");
  }

  let channel = client.subscribe("Turbo::StreamsChannel", {
    signed_stream_name: streamName,
  });

  if (
    !check(channel, {
      "successful subscription": (obj) => obj,
    })
  ) {
    fail("failed to subscribe");
  }

  for (let i = 0; i < MESSAGES_NUM; i++) {
    let startMessage = Date.now();
    let formRes = res.submitForm({
      formSelector: ".chat form",
      fields: { message: `hello from ${userName}` },
    });

    if (
      !check(formRes, {
        "is status 200": (r) => r.status === 200,
      })
    ) {
      fail("couldn't submit message form");
    }

    let message = channel.receive((msg) => {
      return msg.includes(`data-author-id="${userId}"`);
    });

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
