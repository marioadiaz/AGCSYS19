class AddCantidadToOrdenTrabajoListas < ActiveRecord::Migration[8.0]
  def change
    add_column :orden_trabajo_listas, :cantidad, :string
  end
end
