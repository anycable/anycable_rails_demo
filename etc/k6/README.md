# Benchmarking with k6

This folder contains benchmark/stress test scenarios to be used with [k6][].

We rely on the [xk6-cable][] extension, so you must first build a custom k6 executable (following the instructions described in the xk6-cable repo) and keep it in the `etc/k6/` folder:

```sh
<project>/etc/k6> xk6 build v0.32.0 --with github.com/anycable/xk6-cable
```

## Scenarios

All scenarios support the following env vars:

- `CABLE_URL`: WebSocket connection url (defaults to `ws://localhost:8080/cable`).
- `WORKSPACE`: Workspace ID.

### `chat.js`

Connect to a chat room, send N (env `NUM` or 5) messages and expect to receive own messages back:

```sh
./k6 run --vus 20 --duration 10s chat.js
```

This scenario uses ramping VUs executor, you can control the max number of VUs and the total duration via the `MAX` and `TIME` env vars (default to 20 and 120 respectively).

[k6]: https://k6.io
[xk6-cable]: https://github.com/anycable/xk6-cable
