import { csrfToken } from "./csrf";

export function POST(url, data) {
  return JSONrequest(url, "POST", JSON.stringify(data));
}

export function DELETE(url) {
  return JSONrequest(url, "DELETE", "");
}

export function PATCH(url, data) {
  return JSONrequest(url, "PATCH", JSON.stringify(data));
}

export function HTMLrequest(url, method, body) {
  return fetch(url, {
    method,
    credentials: "same-origin",
    headers: {
      "X-CSRF-Token": csrfToken,
      "X-Requested-With": "XMLHttpRequest",
    },
    body
  }).then(
    (response) => {
      if (response.ok) {
        return response.text();
      } else {
        throw new Error("Oops! Request failed");
      }
    }
  );
}

export function JSONrequest(url, method, body) {
  return fetch(url, {
    method,
    credentials: "same-origin",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      "X-CSRF-Token": csrfToken,
      "X-Requested-With": "XMLHttpRequest",
    },
    body
  }).then(
    (response) => {
      if (response.ok) {
        const contentType = response.headers.get("content-type");
        if(contentType && contentType.includes("application/json")) {
          return response.json();
        }
        return response;
      } else {
        throw new Error("Oops! API request failed");
      }
    }
  );
}
