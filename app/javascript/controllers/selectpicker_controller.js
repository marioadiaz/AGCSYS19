import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  init() {
    if (this.initialized) return
    this.initialized = true
    $(this.element).selectpicker()
  }
}