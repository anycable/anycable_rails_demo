const getCSRFAttribute = name => {
  const element = document.querySelector(`meta[name="csrf-${name}"]`);

  return element ? element.getAttribute("content") : "";
};

export const csrfParameter = getCSRFAttribute("param");

export const csrfToken = getCSRFAttribute("token");
