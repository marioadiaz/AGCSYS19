class AgregarFechaInternaToOrdenTrabajoListas < ActiveRecord::Migration[8.0]
  def change
    add_column :orden_trabajo_listas, :fecha_interna, :date
  end
end
