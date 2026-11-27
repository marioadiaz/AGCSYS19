class OrdenTrabajosController < ApplicationController
  include OrdenTrabajosHelper
  BATCH_SIZE = 50  

  before_action :set_orden_trabajo, only: %i[ show edit update destroy ]

  # GET /orden_trabajos or /orden_trabajos.json
  def index
    @contador = OrdenTrabajo.count

    @orden_trabajos, @next_cursor, @has_more =
      obtener_lote(OrdenTrabajo.all, nil)

    @procesos_por_orden = @orden_trabajos.each_with_object({}) do |orden, resultado|
      resultado[orden.id] = cadenatovector(orden.procesos)
    end

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @orden_trabajos }
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

    @registros_por_lista =
      OrdenTrabajoLista
        .where(lista: @listas)
        .includes(:orden_trabajo)
        .order(:lista, :position, :id)
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

    scope = OrdenTrabajo.all

    if q.present?
      termino = "%#{ActiveRecord::Base.sanitize_sql_like(q)}%"

      scope = scope.where(
        "trnum::text ILIKE :termino OR clinom ILIKE :termino",
        termino: termino
      )
    end

    registros, cursor, hay_mas = obtener_lote(scope, nil)

    render json: {
      rows_html: render_to_string(
        partial: "orden_trabajos/orden_trabajo_row",
        collection: registros,
        as: :orden_trabajo
      ),
      forms_html: render_to_string(
        partial: "orden_trabajos/orden_trabajo_form",
        collection: registros,
        as: :orden_trabajo
      ),
      next_cursor: cursor,
      has_more: hay_mas,
      total: scope.count
    }
  end
  
  def cargar_mas
    scope = OrdenTrabajo.all

    if params[:q].present?
      termino = "%#{params[:q].strip}%"

      scope = scope.where(
        "clinom ILIKE :termino OR trnum::text ILIKE :termino",
        termino: termino
      )
    end

    @orden_trabajos, @next_cursor, @has_more =
      obtener_lote(scope, params[:cursor])

    rows_html = render_to_string(
      partial: "orden_trabajos/orden_trabajo_row",
      collection: @orden_trabajos,
      as: :orden_trabajo,
      formats: [:html]
    )

    forms_html = render_to_string(
      partial: "orden_trabajos/orden_trabajo_form",
      collection: @orden_trabajos,
      as: :orden_trabajo,
      formats: [:html]
    )

    render json: {
      rows_html: rows_html,
      forms_html: forms_html,
      next_cursor: @next_cursor,
      has_more: @has_more
    }
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

    # trnum es integer: se conserva el número de la orden original.
    @orden_trabajo.trnum = original.trnum

    if @orden_trabajo.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.after(
              view_context.dom_id(original),
              partial: "orden_trabajos/orden_trabajo_row",
              locals: { orden_trabajo: @orden_trabajo }
            ),
            turbo_stream.append(
              "orden_trabajo_forms",
              partial: "orden_trabajos/orden_trabajo_form",
              locals: { orden_trabajo: @orden_trabajo }
            )
          ]
        end

        format.html do
          redirect_to orden_trabajos_path,
                      notice: "Orden duplicada correctamente."
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend(
            "flash",
            partial: "layouts/flash",
            locals: {
              alert: "No se pudo duplicar: #{@orden_trabajo.errors.full_messages.join(', ')}"
            }
          ), status: :unprocessable_entity
        end

        format.html do
          redirect_to orden_trabajos_path,
                      alert: "No se pudo duplicar la orden."
        end
      end
    end
  end

  def listado
    @proximo_vencimiento_ot = OrdenTrabajo.order('deadline ASC, clinom ASC').first(30)
    @orden_trabajos = OrdenTrabajo.all.order(:clinom, :trnum)
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @orden_trabajos}
      format.xlsx do
      response.headers['Content-Disposition'] =
          'attachment; filename="listado.xlsx"'
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

    campos_permitidos = OrdenTrabajoLista
                          .campos_editables_para(@registro.lista)
                          .map { |campo| campo[:atributo] }

    atributos = params
                  .require(:orden_trabajo_listas)
                  .permit(*campos_permitidos)

    if @registro.update(atributos)

      render turbo_stream: turbo_stream.replace(
        view_context.dom_id(@registro),
        partial: "orden_trabajos/fila_lista",
        locals: {
          reg: @registro,
          guardado: true
        }
      )

    else

      render turbo_stream: turbo_stream.replace(
        view_context.dom_id(@registro),
        partial: "orden_trabajos/fila_lista",
        locals: {
          reg: @registro,
          guardado: false
        }
      ), status: :unprocessable_entity

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
          render :update
        end

        format.html do
          redirect_to orden_trabajo_path(@orden_trabajo),
                      notice: "Orden actualizada correctamente."
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            view_context.dom_id(@orden_trabajo),
            partial: "orden_trabajos/orden_trabajo_row",
            locals: { orden_trabajo: @orden_trabajo }
          ), status: :unprocessable_entity
        end

        format.html do
          render :edit, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /orden_trabajos/1 or /orden_trabajos/1.json
  def destroy
    respond_to do |format|
      if @orden_trabajo.destroy
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove(
              view_context.dom_id(@orden_trabajo)
            ),
            turbo_stream.remove(
              "edit_orden_trabajo_#{@orden_trabajo.id}"
            )
          ]
        end

        format.html do
          redirect_to orden_trabajos_path,
                      notice: "Orden eliminada correctamente."
        end
      else
        format.html do
          redirect_to orden_trabajos_path,
                      alert: "No se pudo eliminar la orden."
        end
      end
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

    def obtener_lote(scope, cursor)
      consulta = scope
        .order(
          Arel.sql("clinom ASC NULLS LAST"),
          Arel.sql("trnum ASC NULLS LAST"),
          :id
        )

      if cursor.present?
        datos = JSON.parse(
          Base64.urlsafe_decode64(cursor)
        )

        consulta = consulta.where(
          condicion_cursor(datos),
          clinom: datos["clinom"],
          trnum: datos["trnum"],
          id: datos["id"]
        )
      end

      registros = consulta.limit(BATCH_SIZE + 1).to_a

      hay_mas = registros.size > BATCH_SIZE
      registros = registros.first(BATCH_SIZE)

      siguiente_cursor =
        if hay_mas && registros.any?
          ultima = registros.last

          Base64.urlsafe_encode64(
            {
              clinom: ultima.clinom,
              trnum: ultima.trnum,
              id: ultima.id
            }.to_json,
            padding: false
          )
        end

      [registros, siguiente_cursor, hay_mas]
    end

    def condicion_cursor(datos)
      condicion_trnum =
        if datos["trnum"].nil?
          "trnum IS NULL AND id > :id"
        else
          "(trnum > :trnum OR trnum IS NULL OR
          (trnum = :trnum AND id > :id))"
        end

      if datos["clinom"].nil?
        "clinom IS NULL AND (#{condicion_trnum})"
      else
        "(clinom > :clinom OR clinom IS NULL OR
        (clinom = :clinom AND (#{condicion_trnum})))"
      end
    end

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

      campos += [:estado_interno, :observaciones,:fecha_interna]

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
