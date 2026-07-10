source "https://rubygems.org"

ruby "3.4.6"

# --- Core Framework ---
gem "rails", "~> 8.1.1"

# --- Activos y Frontend ---
gem "propshaft"                # Nuevo pipeline de assets
gem "importmap-rails"          # Importmap para JS sin Node
gem "turbo-rails"              # Navegación Hotwire
gem "stimulus-rails"           # Controladores JS
gem "cssbundling-rails"        # Manejo de CSS (Bootstrap, Tailwind o Bulma)

#jquery

# --- Base de datos y servidores ---
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"

# --- Formularios y componentes UI ---
gem "simple_form", "~> 5.3"
gem "font-awesome-sass", "~> 6.6"
gem "autoprefixer-rails"

# --- Bootstrap (via cssbundling o importmap) ---
# Si ya usás importmap:
# gem "bootstrap", "~> 5.3", require: false
# Si usás cssbundling:
# Instalar luego con: `bin/rails css:install:bootstrap`

# --- Generación de PDF ---
gem "wicked_pdf"
gem "wkhtmltopdf-binary"

# --- Importar/exportar Excel ---
gem "roo"

gem "caxlsx"
gem "caxlsx_rails"

# --- Otras utilidades ---
gem "mini_racer"               # Motor JS para Rails
gem "bootsnap", require: false # Acelera el arranque
gem "jbuilder"                 # APIs JSON

# --- Caching, cola y ActionCable ---
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# --- Despliegue y optimización ---
gem "kamal", require: false
gem "thruster", require: false

# --- Seguridad y estilos ---
gem "brakeman", require: false
gem "rubocop-rails-omakase", require: false

# --- Desarrollo y depuración ---
group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
end

group :development do
  gem "web-console"
  gem "listen"
  gem "spring"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

# --- Compatibilidad con Windows ---
gem "tzinfo-data", platforms: %i[windows jruby]
