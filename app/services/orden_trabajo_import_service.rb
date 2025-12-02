require "roo"

class OrdenTrabajoImportService
  attr_reader :file, :errors, :imported_count

  def initialize(file)
    @file = file
    @errors = []
    @imported_count = 0
  end

  def call
    return false unless file.present?

    extension = File.extname(file.original_filename).delete('.').downcase
    Rails.logger.info "📂 Importando archivo con extensión: #{extension}"

    begin
      xlsx = Roo::Spreadsheet.open(file.path, extension: extension)
    rescue => e
      Rails.logger.error "❌ Error abriendo archivo: #{e.message}"
      @errors << "No se pudo abrir el archivo: #{e.message}"
      return false
    end

    sheet = xlsx.sheet(0)
    header = sheet.row(1).map(&:to_s).map(&:strip)
    Rails.logger.info "📋 Encabezados detectados: #{header.inspect}"

    required_headers = %w[trnum trcan trcar clinom papel gramaje colores pliego nomprod fecentr cam10 cam12 cam24]
    faltantes = required_headers - header

    if faltantes.any?
      Rails.logger.warn "⚠️ Faltan encabezados: #{faltantes.inspect}"
      @errors << "El archivo no tiene los encabezados esperados. Faltan: #{faltantes.join(', ')}"
      return false
    end

    (2..sheet.last_row).each do |i|
      row_data = Hash[[header, sheet.row(i)].transpose]
      Rails.logger.info "➡️ Fila #{i}: #{row_data.inspect}"

      next if row_data.values.compact.empty? # salta filas vacías

      begin
        orden = OrdenTrabajo.find_or_initialize_by(trnum: row_data["trnum"].to_s.strip)
        orden.assign_attributes(
          trcan:     row_data["trcan"],
          trcar:     safe_date(row_data["trcar"]),
          clinom:    row_data["clinom"],
          papel:     row_data["papel"],
          gramaje:   row_data["gramaje"],
          colores:   row_data["colores"],
          pliego:    row_data["pliego"],
          nomprod:   row_data["nomprod"],
          deadline:  safe_date(row_data["fecentr"]),
          cam10:     row_data["cam10"],
          cam12:     row_data["cam12"],
          cam24:     row_data["cam24"]
        )
        orden.save!
        @imported_count += 1
        Rails.logger.info "✅ Guardada OT #{orden.trnum}"
      rescue => e
        Rails.logger.error "❌ Error en fila #{i}: #{e.message}"
        @errors << "Error en la fila #{i}: #{e.message}"
      end
    end

    Rails.logger.info "✅ Total importadas: #{@imported_count}"
    @errors.empty?
  end

  private

  def safe_date(value)
    return nil if value.blank?
    if value.is_a?(Date)
      value
    elsif value.is_a?(Time)
      value.to_date
    else
      Date.parse(value.to_s) rescue nil
    end
  end
end
