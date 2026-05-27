class AddFechaJtToOrdenTrabajos < ActiveRecord::Migration[8.0]
  def change
    add_column :orden_trabajos, :fecha_jt, :date
  end
end
