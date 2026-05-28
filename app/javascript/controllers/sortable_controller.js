import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = ["tbody"]
  static values = {
    url: String
  }

  connect() {
    this.sortable = Sortable.create(this.tbodyTarget, {
      animation: 150,
      ghostClass: "table-warning",
      dataIdAttr: "data-id",

      onEnd: () => {
        const order = this.sortable.toArray()

        fetch(this.urlValue, {
          method: "PATCH",

          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-CSRF-Token": document
              .querySelector('meta[name="csrf-token"]')
              .content
          },

          body: JSON.stringify({
            order: order
          })
        })
      }
    })
  }

  disconnect() {
    if (this.sortable) {
      this.sortable.destroy()
    }
  }
}