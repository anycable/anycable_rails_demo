// returns true if turbolinks currently showing the cached preview version
// of the page
// See https://github.com/turbolinks/turbolinks#detecting-when-a-preview-is-visible
export const isPreview = () => {
  return document.documentElement.hasAttribute('data-turbolinks-preview');
};
