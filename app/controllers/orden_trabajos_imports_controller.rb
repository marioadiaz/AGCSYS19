class OrdenTrabajosImportsController < ApplicationController
  def new
  end

  def create
    if params[:file].blank?
      redirect_to new_orden_trabajos_import_path, alert: "Debes seleccionar un archivo Excel."
      return
    end

    service = OrdenTrabajoImportService.new(params[:file])

    if service.call
      redirect_to orden_trabajos_path, notice: "✅ Importación completada (#{service.imported_count} registros)."
    else
      @errors = service.errors
      render :new, status: :unprocessable_entity
    end
  end
end
