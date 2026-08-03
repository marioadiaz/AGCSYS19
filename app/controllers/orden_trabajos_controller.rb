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
    Rails.logger.info "PARAMS ORDER: #{params[:order].inspect}"

    orden = params[:order] || []

    orden.each_with_index do |registro_id, index|
      OrdenTrabajoLista
        .where(id: registro_id)
        .update_all(position: index + 1)
    end

    render json: { ok: true }
  end

  def panel_listas
    @listas = OrdenTrabajo::LIST

    # Agrupar registros por lista
    @registros_por_lista = OrdenTrabajoLista
                             .includes(:orden_trabajo)
                             .order(:position)
                             .group_by(&:lista)
  end

  def panel_listas_pdf
    
    cargar_listas
    
    respond_to do |format|
      format.pdf do
        render pdf: "panel_listas",
               template: "orden_trabajos/panel_listas",
               layout: false,
               page_size: "A4",
               orientation: "Landscape",
               margin: {
                 top: 8,
                 bottom: 8,
                 left: 8,
                 right: 8
               },
               footer: {
                 right: "Página [page] de [topage]",
                 font_size: 8,
                 spacing: 3
               }
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
    @orden_trabajo = OrdenTrabajo.find(params[:id])

    @lista_asignada = params[:lista].to_s.strip

    @registro = OrdenTrabajoLista.find_or_create_by!(
      orden_trabajo: @orden_trabajo,
      lista: @lista_asignada
    ) do |r|
      r.position =
      OrdenTrabajoLista.where(lista: @lista_asignada).maximum(:position).to_i + 1
    end

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_back fallback_location: panel_listas_orden_trabajos_path
      end
    end
  end

  def quitar_lista
    @registro = OrdenTrabajoLista.find(params[:id])

    @registro.destroy

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_back fallback_location: panel_listas_orden_trabajos_path
      end
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

  def actualizar_campos
    @registro = OrdenTrabajoLista.find(params[:id])

    permitidos = params.require(:orden_trabajo_listas)
                      .permit(:estado_interno, :observaciones, :cantidad, :fecha_interna)

    @registro.update(permitidos)

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_back fallback_location: panel_listas_orden_trabajos_path
      end
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
      @listas = OrdenTrabajo::LIST

      @registros_por_lista =
        OrdenTrabajoLista
          .includes(:orden_trabajo)
          .order(:position)
          .group_by(&:lista)
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
      @orden_trabajo = OrdenTrabajo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def campos_dinamicos_permitidos
      # extraer todos los símbolos del hash CAMPOS_FORM
      campos = OrdenTrabajosHelper::CAMPOS_FORM.values.flatten(1).map(&:first)

      campos += [:estado_interno, :observaciones, :fecha_interna]

      campos
    end

    # Campos del modelo principal OrdenTrabajo (para create/update)
    def orden_trabajo_params
      params.require(:orden_trabajo).permit(
        :trnum, :trcan, :trcar, :clinom, :papel, :gramaje, :colores,
        :pliego, :nomprod, :fecentr, :procesos, :observaciones,
        :estado_actual, :estado, :deadline, :priority
      )
    end
end
