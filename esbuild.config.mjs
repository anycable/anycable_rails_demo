import * as esbuild from "esbuild"
import path from "path"
import rails from "esbuild-rails"

const watching = process.argv.includes("--watch")

let config = {
  entryPoints: ["entrypoints/application.js"],
  bundle: true,
  sourcemap: true,
  outdir: path.join(process.cwd(), "app/assets/builds"),
  absWorkingDir: path.join(process.cwd(), "frontend"),
  plugins: [rails()],
}

if (watching) {
  let context = await esbuild.context({...config, logLevel: 'info'})
  context.watch()
} else {
  esbuild.build(config)
}
