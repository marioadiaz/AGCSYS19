class OrdenTrabajosController < ApplicationController
  before_action :set_orden_trabajo, only: %i[ show edit update destroy ]

  # GET /orden_trabajos or /orden_trabajos.json
  def index
    @contador = OrdenTrabajo.all.count
    @orden_trabajos = OrdenTrabajo.all.order('clinom ASC, trnum ASC')
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @orden_trabajos}
             format.pdf do
        render pdf: 'listado/pdf', pdf: 'Listado'
      end
    end
  end

  def ordenar_lista
    ids = params[:ids]
    lista = params[:lista]

    OrdenTrabajo.transaction do
      ids.each_with_index do |id, index|
        ot = OrdenTrabajo.find(id)
        next unless ot.lista.to_s.include?(lista)

        ot.update!(position: index + 1)
      end
    end

    render json: { status: "ok" }
  end


  def panel_listas
    @orden_trabajo = OrdenTrabajo.new
    @listas = OrdenTrabajo::LIST

    # Inicializamos el hash vacío
    @ordenes_por_lista = {}

    # Cargamos las órdenes por lista
    @listas.each do |l|
      @ordenes_por_lista[l] =
        OrdenTrabajo.where("lista LIKE ?", "%#{l}%").order(:position)
    end    
  end

  def panel_listas_pdf
    cargar_listas
    respond_to do |format|
      format.pdf do
        render pdf: "panel_listas",
               template: "orden_trabajos/panel_listas",
               layout: false,
               page_size: "A4",
               margin: { top: 10, bottom: 10, left: 10, right: 10 }
      end
    end
  end

  def buscar
    q = params[:q].to_s.strip

    @resultados =
      if q.present?
        OrdenTrabajo.where("trnum::text LIKE ? OR clinom ILIKE ?", "%#{q}%", "%#{q}%").limit(50)
      else
        []
      end

    render turbo_stream: turbo_stream.update("resultados_busqueda", partial: "orden_trabajos/resultados", locals: { resultados: @resultados })
  end

  def asignar_lista
    @orden_trabajo   = OrdenTrabajo.find(params[:id])
    @lista_asignada  = params[:lista].to_s.strip

    if @lista_asignada.present?
      listas_actuales = @orden_trabajo.lista.to_s.split(",").reject(&:blank?)
      unless listas_actuales.include?(@lista_asignada)
        listas_actuales << @lista_asignada
        @orden_trabajo.update(lista: listas_actuales.join(",") + ",")
      end
    end

    respond_to do |format|
      format.turbo_stream   # asignar_lista.turbo_stream.erb
      format.html { redirect_back fallback_location: panel_listas_orden_trabajos_path, notice: "Asignado correctamente." }
    end
  end

  def quitar_lista
    @orden_trabajo = OrdenTrabajo.find(params[:id])

    # Listas actuales como array limpio
    listas = @orden_trabajo.lista.to_s.split(",").reject(&:blank?)

    # Quitamos la ÚLTIMA lista
    listas.pop

    # Guardamos el nuevo valor (si queda vacío, guardamos nil)
    @orden_trabajo.update(lista: listas.any? ? listas.join(",") + "," : nil)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: panel_listas_orden_trabajos_path, notice: "Quitado correctamente." }
    end
  end

  def copy
    original = OrdenTrabajo.find(params[:id])
    @orden_trabajo = original.dup

    # evitar duplicados del trnum (podés ajustar)
    @orden_trabajo.trnum = "#{original.trnum}-C"

    if @orden_trabajo.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.after(
            view_context.dom_id(original),          # 👈 FIX IMPORTANTE
            partial: "orden_trabajo_row",
            locals: { orden_trabajo: @orden_trabajo }
          )
        end

        format.html { redirect_to orden_trabajos_path, notice: "Orden duplicada correctamente" }
      end
    else
      Rails.logger.error "❌ Error al duplicar: #{@orden_trabajo.errors.full_messages}"

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend(
            "flash",
            partial: "layouts/flash",
            locals: { alert: "❌ No se pudo duplicar la orden: #{@orden_trabajo.errors.full_messages.join(', ')}" }
          ), status: :unprocessable_entity
        end

        format.html { redirect_to orden_trabajos_path, alert: "❌ No se pudo duplicar la orden" }
      end
    end
  end

  def listado
    @proximo_vencimiento_ot = OrdenTrabajo.order('deadline ASC, clinom ASC').first(30)
    @orden_trabajos = OrdenTrabajo.all.order('clinom ASC, trnum ASC')
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @orden_trabajos}
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="listado.xlsx"'
      end
      format.pdf do
        render pdf: 'listado/pdf', pdf: 'Listado',
                  :orientation => 'landscape',
                  footer: {
                   right: "Página [page] de [topage]",
                   font_size: 8,
                   spacing: 5
                 }
      end      
    end
  end

  # GET /orden_trabajos/1 or /orden_trabajos/1.json
  def show
  end

  # GET /orden_trabajos/new
  def new
    @orden_trabajo = OrdenTrabajo.new
  end

  # GET /orden_trabajos/1/edit
  def edit
  end

  def actualizar_campo1
    @orden_trabajo = OrdenTrabajo.find(params[:id])

    if @orden_trabajo.update(campo1: params[:campo1])
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: panel_listas_orden_trabajos_path }
      end
    else
      head :unprocessable_entity
    end
  end

  # POST /orden_trabajos or /orden_trabajos.json
  def create
    @orden_trabajo = OrdenTrabajo.new(orden_trabajo_params)

    respond_to do |format|
      if @orden_trabajo.save
        format.html { redirect_to @orden_trabajo, notice: "Orden trabajo was successfully created." }
        format.json { render :show, status: :created, location: @orden_trabajo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @orden_trabajo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orden_trabajos/1 or /orden_trabajos/1.json
  def update
    @orden_trabajo = OrdenTrabajo.find(params[:id])
    
    if @orden_trabajo.update(orden_trabajo_params)
      respond_to do |format|
        format.turbo_stream do
          @context = params[:context].presence || "index"
          render :update # usa update.turbo_stream.erb
        end
        format.html { redirect_to orden_trabajo_path, notice: "Orden actualizada" }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orden_trabajos/1 or /orden_trabajos/1.json
  def destroy
    @orden_trabajo = OrdenTrabajo.find(params[:id])
    @orden_trabajo.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to orden_trabajos_path, notice: "Orden eliminada correctamente." }
    end
  end

  # ESTE SECTOR DEL CONTROLADOR ES PARA LAS DIFERENTES VIEWS DE IMPRESIÓN Y POST
  # ------------------------------------------------------------------------
  def digital
  end
  def offset1
  end
  def offset2
  end
  def post1
  end
  def post2
  end
  def post3
  end
  def post4
  end
  def post5
  end
  def post6
  end
  def post7
  end
  # FIN DEL VIEW PARA LAS PANTALLAS
  # ------------------------------------------------------------------------

  # lISTADO DE LOS TRABAJOS QUE ENTRARON EN LOS ÙLTIMOS 3 DÌAS
  def nueva_ot
    @orden_trabajos = OrdenTrabajo.order('trcar DESC NULLS LAST').first(25)
  end
  # FIN lISTADO DE LOS TRABAJOS QUE ENTRARON EN LOS ÙLTIMOS 3 DÌAS

  # lISTADO DE LOS TRABAJOS PROXIMOS Y LISTOS PARA ENTRAR EN MÁQUINA
  # -----------------------------------------------------------------
  def planificacion_taller
    @orden_trabajos = OrdenTrabajo.all.order(:deadline)
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @orden_trabajos}
      format.pdf do
        render pdf: 'excel/pdf', pdf: 'excel'
      end
    end
  end

  # lISTADO EN PDF DE LOS TRABAJOS PROXIMOS Y LISTOS PARA ENTRAR EN MÁQUINA
  def planificacion_tallerPDF
      @orden_trabajos = OrdenTrabajo.all.order('clinom ASC')
      respond_to do |format|
        format.html
        format.js
        format.json
        format.pdf do
          render pdf: 'excel/pdf', pdf: 'excel',
                    :orientation => 'landscape',
                    footer: {
                     right: "Página [page] de [topage]",
                     font_size: 8,
                     spacing: 5
                   }
        end
      end
    end

  # FIN DEL LISTADO DE TRABAJOS PROXIMOS Y LISTOS PARA ENTRAR EN MÁQUINA
  # ----------------------------------------------------------------------------
  def proximo_vencer
    # Trae las órdenes de trabajo con fecha de entrega (deadline) dentro de los próximos 7 días, por ejemplo
    @orden_trabajos = OrdenTrabajo
                        .order(:deadline)
  end

  private
    def cargar_listas
      @orden_trabajo = OrdenTrabajo.new
      @listas = OrdenTrabajo::LIST

      @ordenes_por_lista = {}

      @listas.each do |l|
        @ordenes_por_lista[l] =
          OrdenTrabajo.where("lista LIKE ?", "%#{l}%").order(:position)
      end
    end

    def listado_trabajo
      @orden_trabajos = OrdenTrabajo.order('deadline, clinom')
       respond_to do |format|
      format.html
      format.js
      format.json { render json: @orden_trabajos}
    end
    end

    def listado_excel1
      @orden_trabajos = OrdenTrabajo.all
    end

    def set_orden_trabajo
      @orden_trabajo = OrdenTrabajo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def orden_trabajo_params
      params.expect(orden_trabajo: [ :trnum, :trcan, :trcar, :clinom, :papel, :gramaje, :colores, :pliego, :nomprod, :fecentr, :cam10, :cam12, :cam24, :procesos, :observaciones, :estado_actual, :estado, :deadline, :priority ])
    end
end
