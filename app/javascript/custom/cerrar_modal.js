document.addEventListener("turbo:submit-end", (event) => {
  if (!event.detail.success) return;

  const modalElement = document.querySelector(".modal.show");

  if (modalElement) {
    const modal = bootstrap.Modal.getInstance(modalElement);

    if (modal) {
      modal.hide();
    }
  }

  // Limpieza forzada
  document.body.classList.remove("modal-open");

  document.querySelectorAll(".modal-backdrop").forEach((el) => {
    el.remove();
  });

  document.body.style.removeProperty("padding-right");
});