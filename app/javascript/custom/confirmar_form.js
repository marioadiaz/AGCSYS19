document.addEventListener("turbo:submit-end", function(event) {
  const boton = event.target.querySelector(".btn-confirmar");

  if (boton && event.detail.success) {
    boton.textContent = "✅ Ok";
    boton.classList.remove("btn-success");
    boton.classList.add("btn-primary");

    
  }
});