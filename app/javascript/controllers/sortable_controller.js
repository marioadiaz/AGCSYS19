import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tbody"]
  static values = { url: String }

  connect() {
    console.log("🧩 sortable para lista activado:", this.urlValue)

    this.dragged = null

    this.tbodyTarget.addEventListener("dragstart", this.onDragStart.bind(this))
    this.tbodyTarget.addEventListener("dragover", this.onDragOver.bind(this))
    this.tbodyTarget.addEventListener("drop", this.onDrop.bind(this))
  }

  onDragStart(event) {
    this.dragged = event.target.closest("tr")
    this.dragged.classList.add("table-warning")
  }

  onDragOver(event) {
    event.preventDefault()

    const target = event.target.closest("tr")

    // 🚫 Evita mezclar entre tablas
    if (!target || target.parentElement !== this.tbodyTarget) {
      return
    }

    if (target && target !== this.dragged) {
      const rect = target.getBoundingClientRect()
      const midpoint = rect.top + rect.height / 2

      if (event.clientY < midpoint) {
        this.tbodyTarget.insertBefore(this.dragged, target)
      } else {
        this.tbodyTarget.insertBefore(this.dragged, target.nextSibling)
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
      .map(row => row.id.replace("ot_", "")) // ✔️ ID correcto

    console.log("📦 Nuevo orden enviado:", ids)

    fetch(this.urlValue, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Accept": "application/json"
      },
      body: JSON.stringify({ ids: ids })
    })
  }
}
