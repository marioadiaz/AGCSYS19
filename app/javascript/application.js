// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "custom/scroll_top"
import "custom/buscador_datos"
import "custom/selectpicker"
import "custom/confirmar_form"
import "custom/cerrar_modal"

import "jquery"
window.$ = window.jQuery = globalThis.jQuery
import * as bootstrap from "bootstrap"
import "bootstrap.bundle"
import "@fortawesome/fontawesome-free"

document.addEventListener("turbo:load", () => {
  // console.log("✅ Turbo y Bootstrap funcionando con assets locales");
});
