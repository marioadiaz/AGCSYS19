class AddFechaInternaToOrdenTrabajoListas < ActiveRecord::Migration[8.0]
  def change
    add_column :orden_trabajos, :fecha_interna, :date
  end
end
