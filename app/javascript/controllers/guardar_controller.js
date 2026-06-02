import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    console.log("GUARDAR CONTROLLER CONECTADO")

    this.element.addEventListener("turbo:submit-end", (event) => {

      console.log("FORMULARIO ENVIADO")

      if (event.detail.success) {

        const boton = this.element.querySelector(".guardar-btn")

        if (boton) {
          boton.value = "OK"
        }
      }

    })
  }

}