class RemoveFechaInternaToOrdenTrabajoListas < ActiveRecord::Migration[8.0]
  def change
    remove_column :orden_trabajos, :fecha_interna
  end
end
