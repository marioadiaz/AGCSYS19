import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("🔥 reorderable conectado en:", this.element)

    // 🧠 IMPORTANTE:
    // agregamos sortable SIN eliminar otros data-controllers existentes
    this.element.setAttribute(
      "data-controller",
      (this.element.getAttribute("data-controller") || "") + " sortable"
    )
  }
}
