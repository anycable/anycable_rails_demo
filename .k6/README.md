# Benchmarking with k6

This folder contains benchmark/stress test scenarios to be used with [k6][].

We rely on the [xk6-cable][] extension, so you must first build a custom k6 executable (following the instructions described in the xk6-cable repo) and keep it in the `.k6/` folder.

## Scenarios

All scenarios support the following env vars:

- `CABLE_URL`: WebSocket connection url (defaults to `ws://localhost:8080/cable`).
- `WORKSPACE`: Workspace ID.

### `chat.js`

Connect to a chat room, send N (env `NUM` or 5) messages and expect to receive own messages back:

```sh
./k6 run --vus 20 --duration 10s chat.js
```

[k6]: https://k6.io
[xk6-cable]: https://github.com/anycable/xk6-cable
