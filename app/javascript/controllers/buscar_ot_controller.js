import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {

  static targets = ["input", "lista", "resultados"]

  buscar() {
    const query = this.hasInputTarget
      ? this.inputTarget.value.trim()
      : ""

    const lista = this.hasListaTarget
      ? this.listaTarget.value.trim()
      : ""

    fetch(`/orden_trabajos/buscar?q=${encodeURIComponent(query)}&lista=${encodeURIComponent(lista)}`, {
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
        "X-Requested-With": "XMLHttpRequest"
      }
    })
      .then(r => r.text())
      .then(html => Turbo.renderStreamMessage(html))
  }

  asignar(event) {
    event.preventDefault()

    const otId = event.currentTarget.dataset.otId

    const lista = this.hasListaTarget
      ? this.listaTarget.value.trim()
      : ""

    console.log("Asignando:", otId, "a", lista)

    fetch(`/orden_trabajos/${otId}/asignar_lista`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Accept": "text/vnd.turbo-stream.html",
        "X-Requested-With": "XMLHttpRequest",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        lista: lista
      })
    })
      .then(r => r.text())
      .then(html => {
        Turbo.renderStreamMessage(html)
      })
  }
}