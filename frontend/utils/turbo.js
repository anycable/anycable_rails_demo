// returns true if Turbo currently showing the cached preview version
// of the page
// See https://turbo.hotwire.dev/handbook/building#detecting-when-a-preview-is-visible
export const isPreview = () => {
  return document.documentElement.hasAttribute('data-turbo-preview');
};
