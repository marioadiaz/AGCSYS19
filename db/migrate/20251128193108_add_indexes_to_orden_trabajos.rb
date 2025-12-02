class AddIndexesToOrdenTrabajos < ActiveRecord::Migration[8.0]
  def change
    add_index :orden_trabajos, :clinom, name: "index_orden_trabajos_on_clinom"
    add_index :orden_trabajos, :trnum, name: "index_orden_trabajos_on_trnum"
  end
end
