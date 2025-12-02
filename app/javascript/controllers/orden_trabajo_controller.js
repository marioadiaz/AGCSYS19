import { Controller } from "@hotwired/stimulus"

// Controlador Stimulus: orden-trabajo
// Se activa con data-controller="orden-trabajo"
export default class extends Controller {
  static targets = ["submitButton", "row"]

  actualizado(event) {
    //console.log("✅ Método actualizado() ejecutado")
    //console.log("event.detail.success:", event.detail.success)

    const form = event.target
    const boton = this.hasSubmitButtonTarget
      ? this.submitButtonTarget
      : form.querySelector('button[type="submit"], input[type="submit"]')

    //console.log("➡️ Botón detectado:", boton)
  }

  copy(event) {
    const id = event.currentTarget.dataset.id

    fetch(`/orden_trabajos/${id}/copy`, {
      method: "POST",
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Content-Type": "application/json"
      },
      body: "{}"
    })
  }

}
