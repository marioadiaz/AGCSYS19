import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = [
    "rows",
    "forms",
    "sentinel",
    "search",
    "status"
  ]

  static values = {
    searchUrl: String,
    loadUrl: String,
    nextCursor: String,
    hasMore: Boolean
  }

  
  connect() {
    this.loading = false
    this.searchTimer = null
    this.currentQuery = ""

    this.observer = new IntersectionObserver(
      (entries) => {
        if (entries.some(entry => entry.isIntersecting)) {
          this.cargarMas()
        }
      },
      {
        root: null,
        rootMargin: "400px",
        threshold: 0
      }
    )

    this.observer.observe(this.sentinelTarget)

    // Sincronizar los procesos antes de enviar el formulario.
    this.sincronizarAntesDeEnviar = (event) => {
      const form = event.target

      this.rowsTarget.querySelectorAll(".selectpicker").forEach(select => {
        const hidden = document.getElementById(select.dataset.hiddenId)

        if (!hidden || hidden.form !== form) return

        const seleccionados = Array.from(
          select.selectedOptions
        ).map(option => option.value)

        hidden.value = seleccionados.join(",")
      })
    }

    this.element.addEventListener(
      "submit",
      this.sincronizarAntesDeEnviar,
      true
    )

    // Detectar filas reemplazadas por Turbo.
    this.mutationObserver = new MutationObserver(() => {
      this.inicializarSelectpickers()
    })

    this.mutationObserver.observe(this.rowsTarget, {
      childList: true
    })

    this.inicializarSelectpickers()
  }
    
  disconnect() {
    this.observer?.disconnect()
    this.mutationObserver?.disconnect()

    this.element.removeEventListener(
      "submit",
      this.sincronizarAntesDeEnviar,
      true
    )

    clearTimeout(this.searchTimer)
  }

  // -------------------------------------------------------
  // BÚSQUEDA
  // -------------------------------------------------------

  buscar() {
    const query = this.hasInputTarget
      ? this.inputTarget.value.trim()
      : ""

    const lista = this.hasListaTarget
      ? this.listaTarget.value.trim()
      : ""

    fetch(`/orden_trabajos/buscar?q=${encodeURIComponent(query)}&lista=${encodeURIComponent(lista)}`, {
      headers: {
        "Accept": "application/json",
        "X-Requested-With": "XMLHttpRequest"
      }
    })
      .then(response => {
        if (!response.ok) {
          throw new Error(`Error HTTP ${response.status}`)
        }

        return response.json()
      })
      .then(data => {
        this.resultadosTarget.innerHTML = data.resultados_html

        console.log("Resultados encontrados:", data.total)
      })
      .catch(error => {
        console.error("Error al buscar órdenes:", error)

        this.resultadosTarget.innerHTML = `
          <div class="alert alert-danger mt-3">
            No se pudieron cargar los resultados.
          </div>
        `
      })
  }

  // -------------------------------------------------------
  // CARGA PROGRESIVA
  // -------------------------------------------------------

  async cargarMas() {
    if (this.loading || !this.hasMoreValue) return

    this.loading = true

    this.statusTarget.textContent = "Cargando más órdenes..."

    const url = new URL(
      this.loadUrlValue,
      window.location.origin
    )

    url.searchParams.set("cursor", this.nextCursorValue || "")
    url.searchParams.set("q", this.currentQuery || "")

    try {
      const response = await fetch(url, {
        headers: {
          Accept: "application/json"
        },
        credentials: "same-origin"
      })

      if (!response.ok) {
        throw new Error("Error al cargar órdenes")
      }

      const data = await response.json()

      this.rowsTarget.insertAdjacentHTML(
        "beforeend",
        data.rows_html
      )

      this.formsTarget.insertAdjacentHTML(
        "beforeend",
        data.forms_html
      )

      this.actualizarEstado(data)

      this.inicializarSelectpickers()

    } catch (error) {
      console.error(error)
      this.statusTarget.textContent =
        "Error al cargar más órdenes. Volvé a desplazarte para intentar nuevamente."
    } finally {
      this.loading = false
    }
  }

  actualizarEstado(data) {
    this.nextCursorValue = data.next_cursor || ""
    this.hasMoreValue = Boolean(data.has_more)

    const contador = document.getElementById("contador_ordenes")

    if (contador && data.total !== undefined) {
      contador.textContent = data.total
    }

    if (data.has_more) {
      this.statusTarget.textContent =
        "Desplazate hacia abajo para cargar más órdenes."
    } else if (data.total === 0) {
      this.statusTarget.textContent =
        "No se encontraron órdenes."
    } else {
      this.statusTarget.textContent =
        "No hay más órdenes para mostrar."
    }
  }

  // -------------------------------------------------------
  // BOOTSTRAP SELECT
  // -------------------------------------------------------
  inicializarSelectpickers() {
    if (window.$ && $.fn.selectpicker) {
      $(this.rowsTarget).find(".selectpicker").selectpicker("render");
    }

    this.restaurarConfirmaciones();
  }
  // -------------------------------------------------------
  // DUPLICAR ORDEN
  // -------------------------------------------------------

  async copy(event) {
    event.preventDefault()

    const url = event.currentTarget.dataset.url

    if (!url) return

    if (!confirm("¿Duplicar esta orden de trabajo?")) return

    const token = document.querySelector(
      'meta[name="csrf-token"]'
    )?.content

    try {
      const response = await fetch(url, {
        method: "POST",
        headers: {
          Accept: "text/vnd.turbo-stream.html",
          "X-CSRF-Token": token
        },
        credentials: "same-origin"
      })

      const contentType = response.headers.get("content-type") || ""

      if (!response.ok) {
        throw new Error("No se pudo duplicar la orden")
      }

      if (contentType.includes("turbo-stream")) {
        Turbo.renderStreamMessage(await response.text())
      } else {
        throw new Error("Respuesta inesperada del servidor")
      }

    } catch (error) {
      console.error(error)
      alert(error.message)
    }
  }

  // -------------------------------------------------------
  // ACTUALIZACIÓN
  // -------------------------------------------------------
  actualizado(event) {
    const form = event.target;

    if (!event.detail.success) return;

    const boton = Array.from(
      document.querySelectorAll(
        'button[type="submit"][form]'
      )
    ).find(element => element.form === form);

    if (!boton) return;

    // Guardar la confirmación para sobrevivir al reemplazo Turbo.
    const fila = boton.closest("tr");

    if (fila) {
      fila.dataset.actualizado = "true";
    }

    boton.textContent = "✅ Ok";
  }

  // -------------------------------------------------------
  // Efecto ✅ Ok
  // -------------------------------------------------------
  restaurarConfirmaciones() {
    this.rowsTarget.querySelectorAll(
      'tr[data-actualizado="true"]'
    ).forEach(fila => {
      const boton = fila.querySelector(
        'button[type="submit"]'
      );

      if (boton) {
        boton.textContent = "✅ Ok";
      }
    });
  }

}