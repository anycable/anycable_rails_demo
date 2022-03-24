const esbuild = require("esbuild");
const rails = require("esbuild-rails");
const path = require("path");

esbuild
  .build({
    entryPoints: ["entrypoints/application.js"],
    bundle: true,
    sourcemap: true,
    outdir: path.join(process.cwd(), "app/assets/builds"),
    absWorkingDir: path.join(process.cwd(), "frontend"),
    watch: process.argv.includes("--watch"),
    plugins: [rails()],
  })
  .catch(() => process.exit(1));
