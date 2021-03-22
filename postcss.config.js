module.exports = {
  plugins: {
    'postcss-modules': {
      generateScopedName: (name, filename, _css) => {
        const matches = filename.match(/\/frontend\/components\/?(.*)\/index.css$/);
        if (!matches) return name;

        const component = matches[1].replace("/", "--");

        return `c-${component}-${name}`;
      },
    },
    'postcss-import': {},
    'postcss-nested': {},
    'tailwindcss': {},
    autoprefixer: {}
  },
}
