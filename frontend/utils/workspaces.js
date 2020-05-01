const STORAGE_KEY = "any_wrks";
const HISTORY_SIZE = 5;

export function visitedWorkspaces() {
  let val = localStorage.getItem(STORAGE_KEY);
  if (val) {
    const list = JSON.parse(val);
    return list;
  }
}

export function rememberWorkspace(url, name) {
  const current = visitedWorkspaces() || [];

  if (current.find((wrk) => wrk.url == url)) return;

  current.unshift({url, name});

  if (current.length > HISTORY_SIZE) current.pop();

  localStorage.setItem(STORAGE_KEY, JSON.stringify(current));
}
