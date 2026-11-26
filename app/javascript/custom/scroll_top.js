document.addEventListener("turbo:load", () => {
  const mybutton = document.getElementById("myBtn");
  if (!mybutton) return;

  window.addEventListener("scroll", () => {
    if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
      mybutton.style.display = "block";
    } else {
      mybutton.style.display = "none";
    }
  });

  window.topFunction = function() {
    window.scrollTo({ top: 0, behavior: "smooth" });
  };
  console.log("✅ scroll_top.js cargado correctamente");
});
