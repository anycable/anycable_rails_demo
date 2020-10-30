module.exports = {
  future: {
    purgeLayersByDefault: true,
  },
  purge: {
    content: [
      './frontend/javascript/**/*_controller.js',
      './app/**/*.html.erb',
    ],
  },
  theme: {
    extend: {
      colors: {
        red: {
          default: '#ff5e5e',
          lighter: '#fd7373',
          darker: '#f64242',
        },
        black: '#363636',
        grey: '#646473',
      },
      gridTemplateColumns: {
        'chat': '30% minmax(70%, 1fr)',
      },
    },
  },
  variants: {},
  plugins: [],
}
