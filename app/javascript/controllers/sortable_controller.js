import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tbody"]
  static values = { url: String }

  connect() {
    console.log("🧩 Controlador sortable conectado")
    this.dragged = null

    this.tbodyTarget.addEventListener("dragstart", this.onDragStart.bind(this))
    this.tbodyTarget.addEventListener("dragover", this.onDragOver.bind(this))
    this.tbodyTarget.addEventListener("drop", this.onDrop.bind(this))
  }

  onDragStart(event) {
    this.dragged = event.target
    event.target.classList.add("table-warning")
  }

  onDragOver(event) {
    event.preventDefault()
    const target = event.target.closest("tr")
    if (target && target !== this.dragged) {
      const tbody = this.tbodyTarget
      const rect = target.getBoundingClientRect()
      const midpoint = rect.top + rect.height / 2
      if (event.clientY < midpoint) {
        tbody.insertBefore(this.dragged, target)
      } else {
        tbody.insertBefore(this.dragged, target.nextSibling)
      }
    }
  }

  onDrop(event) {
    event.preventDefault()
    this.dragged.classList.remove("table-warning")
    this.updateOrder()
  }

  updateOrder() {
    const ids = Array.from(this.tbodyTarget.querySelectorAll("tr"))
      .map(row => row.dataset.id)
    console.log("📦 Nuevo orden a enviar:", ids)

    fetch(this.urlValue, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ ids: ids })
    })
    .then(response => {
      if (response.ok) {
        console.log("✅ Orden actualizado correctamente")
      } else {
        console.error("❌ Error al actualizar orden", response)
      }
    })
    .catch(err => console.error("💥 Error de red:", err))
  }
}
