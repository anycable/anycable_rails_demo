import { defineConfig } from "vite";
import jsbundling from "rails-vite-plugin/jsbundling";

export default defineConfig({
  server: {
    host: 'localhost'
  },
  plugins: [
    jsbundling({
      sourceDir: "frontend",
    }),
  ],
});
