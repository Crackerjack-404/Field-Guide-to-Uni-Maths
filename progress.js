document.addEventListener("scroll", () => {
  const scrollTop = document.documentElement.scrollTop;
  const height =
    document.documentElement.scrollHeight -
    document.documentElement.clientHeight;
  const scroll = scrollTop / height;
  document.body.style.setProperty("--scroll", scroll);
});
