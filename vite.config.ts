import { defineConfig } from 'vite';
import RubyPlugin from 'vite-plugin-ruby';
import StimulusHMR from 'vite-plugin-stimulus-hmr';

export default defineConfig({
  plugins: [
    RubyPlugin(),
    StimulusHMR(),
  ],
});
