let user;

export const currentUser = () => {
  if (user) return user;

  const id = getMeta("id");
  const name = getMeta("name");

  user = {id, name};
  return user;
}

function getMeta(name) {
  const element = document.head.querySelector(`meta[name='current-user-${name}']`)
  if (element) {
    return element.getAttribute("content")
  }
};
