document.addEventListener("turbo:submit-end", (event) => {
  if (!event.detail.success) return;

  const modalElement = event.target.closest(".modal");

  if (!modalElement) return;

  // quitar foco de cualquier elemento dentro del modal
  if (document.activeElement) {
    document.activeElement.blur();
  }

  const modal = bootstrap.Modal.getInstance(modalElement);

  modalElement.addEventListener("hidden.bs.modal", () => {
    document.querySelectorAll(".modal-backdrop").forEach(el => el.remove());

    document.body.classList.remove("modal-open");
    document.body.style.removeProperty("padding-right");
    document.body.style.removeProperty("overflow");
  }, { once: true });

  modal.hide();
});