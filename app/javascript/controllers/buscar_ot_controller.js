import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "resultados", "lista"]

  connect() {
    console.log("🟢 Controlador buscar-ot CONECTADO")
  }

  buscar() {
    const query = this.inputTarget.value.trim()
    const lista = this.listaTarget?.value?.trim() || ""   // <-- capturamos la lista seleccionada

    console.log("🔎 Buscando:", query, " | Lista:", lista)

    fetch(`/orden_trabajos/buscar?q=${encodeURIComponent(query)}&lista=${encodeURIComponent(lista)}`, {
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
        "X-Requested-With": "XMLHttpRequest"
      }
    })
    .then(r => {
      console.log("📨 Respuesta status:", r.status)
      return r.text()
    })
    .then(html => {
      console.log("📨 Contenido recibido (Turbo Stream):")


      Turbo.renderStreamMessage(html)
    })
  }
}
