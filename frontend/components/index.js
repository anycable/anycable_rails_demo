import { application } from "../init/stimulus";

const context = require.context(".", true, /index.js$/)
context.keys().forEach((path) => {
  const mod = context(path);

  if (!mod.Controller) return;

  const identifier = path.replace(/^\.\//, '')
    .replace(/\/index\.js$/, '')
    .replace(/\//, '--');

  application.register(identifier, mod.Controller);
});
