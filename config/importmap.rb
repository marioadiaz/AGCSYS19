# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "jquery", to: "jquery.js"
#pin "jquery", to: "jquery.min.js"
#pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8
pin "bootstrap", to: "bootstrap.js"
pin "bootstrap.bundle", to: "bootstrap.bundle.min.js"
#pin "bootstrap-select", to: "bootstrap-select.min.js"

pin "@fortawesome/fontawesome-free", to: "fontawesome-free/js/all.js"
pin "custom/scroll_top", to: "custom/scroll_top.js"
pin "custom/buscador_datos", to: "custom/buscador_datos.js"
pin "custom/selectpicker", to: "custom/selectpicker.js"

