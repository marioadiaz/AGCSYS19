Rails.application.routes.draw do
  # 🏠 Página principal: lista de órdenes de trabajo
  root to: "orden_trabajos#index"

  # =========================================================
  # 📦 ÓRDENES DE TRABAJO
  # =========================================================
  get 'orden_trabajos/panel_listas_pdf', to: 'orden_trabajos#panel_listas_pdf',     as: :panel_listas_pdf_orden_trabajos

  resources :orden_trabajos do
    # ---- RUTAS COLLECTION (sin ID) -------------------------
    collection do

      get  :buscar
      get  :panel_listas

      # 🔁 Reordenamiento con drag & drop
      get  :index_reorder
      post :reorder
      
      # 📅 Vistas específicas
      get :planificacion_taller
      get :planificacion_tallerPDF

      # 🖨️ Vistas de procesos post (1–7)
      get :listado
      get :offset1
      get :offset2
      get :digital
      get :post1
      get :post2
      get :post3
      get :post4
      get :post5
      get :post6
      get :post7
    end
    
    # ---- RUTAS MEMBER (actúan sobre un ID) -----------------
    member do
      post :copy          # correcta
      patch :asignar_lista  # CORRECTO
      patch :actualizar_campo1     # ← corregido: debe ir en member
      
    end
  end
  
    # =========================================================
  # 📥 IMPORTACIÓN DESDE EXCEL
  # =========================================================
  resources :orden_trabajos_imports, only: [:new, :create]

  # =========================================================
  # 🧭 RUTAS “CORTAS” (alias legibles)
  # =========================================================
  # 🔸 Estas rutas son alias que apuntan a las acciones del mismo controlador
  # 🔸 No generan conflictos porque tienen nombres distintos de los helpers Rails estándar
  
  get "index_reorder",             to: "orden_trabajos#index_reorder",          as: :index_reorder
  patch "orden_trabajos/ordenar_lista", to: "orden_trabajos#ordenar_lista", as: :ordenar_lista_orden_trabajos

  patch "orden_trabajos/:id/quitar_lista", to: "orden_trabajos#quitar_lista", as: :quitar_lista_orden_trabajo  

  
  
  get 'panel_listas',              to: 'orden_trabajos#panel_listas',           as: :panel_listas

  get 'listado',                   to: 'orden_trabajos#listado',                as: :listado
  get 'offset1',                   to: 'orden_trabajos#offset1',                as: :offset1
  get 'offset2',                   to: 'orden_trabajos#offset2',                as: :offset2
  get 'digital',                   to: 'orden_trabajos#digital',                as: :digital
  
  get 'post1',                     to: 'orden_trabajos#post1',                  as: :post1
  get 'post2',                     to: 'orden_trabajos#post2',                  as: :post2
  get 'post3',                     to: 'orden_trabajos#post3',                  as: :post3
  get 'post4',                     to: 'orden_trabajos#post4',                  as: :post4
  get 'post5',                     to: 'orden_trabajos#post5',                  as: :post5
  get 'post6',                     to: 'orden_trabajos#post6',                  as: :post6
  get 'post7',                     to: 'orden_trabajos#post7',                  as: :post7
  
  get "planificacion_taller",      to: "orden_trabajos#planificacion_taller",   as: :planificacion_taller
  get "planificacion_tallerPDF",   to: "orden_trabajos#planificacion_tallerPDF",as: :planificacion_tallerPDF
  
end
