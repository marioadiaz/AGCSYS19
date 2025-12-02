// app/javascript/controllers/buscar_ot_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "resultados", "lista"]

  connect() {
    console.log("🟢 Controlador buscar-ot CONECTADO")
  }

  buscar() {
    const query = this.inputTarget.value.trim()
    const lista  = this.listaTarget?.value?.trim() || ""

    console.log("🔎 Buscando:", query, "| Lista:", lista)

    fetch(`/orden_trabajos/buscar?q=${encodeURIComponent(query)}&lista=${encodeURIComponent(lista)}`, {
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
        "X-Requested-With": "XMLHttpRequest"
      }
    })
      .then(r => r.text())
      .then(html => {
        Turbo.renderStreamMessage(html)
      })
  }

  asignar(event) {
    event.preventDefault()

    const button = event.currentTarget
    const otId   = button.dataset.otId
    const lista  = this.listaTarget?.value?.trim() || ""

    if (!lista) {
      alert("Seleccioná una lista en el desplegable antes de asignar.")
      return
    }

    console.log("✅ Asignando OT", otId, "a lista", lista)

    const token = document.querySelector("meta[name='csrf-token']")?.content

    fetch(`/orden_trabajos/${otId}/asignar_lista`, {
      method: "PATCH",
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "X-CSRF-Token": token
      },
      body: new URLSearchParams({ lista })
    })
      .then(r => r.text())
      .then(html => {
        Turbo.renderStreamMessage(html)
      })
  }
}
