document.addEventListener("turbo:submit-end", (event) => {
  if (!event.detail.success) return;

  const modalEl = event.target.closest(".modal");

  if (modalEl) {
    const modal = bootstrap.Modal.getInstance(modalEl);

    modal.hide();

    modalEl.addEventListener(
      "hidden.bs.modal",
      () => {
        document.querySelectorAll(".modal-backdrop").forEach(e => e.remove());
        document.body.classList.remove("modal-open");
        document.body.style.removeProperty("padding-right");
      },
      { once: true }
    );
  }
});