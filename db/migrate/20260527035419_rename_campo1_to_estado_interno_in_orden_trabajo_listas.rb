class RenameCampo1ToEstadoInternoInOrdenTrabajoListas < ActiveRecord::Migration[8.0]
  def change
    rename_column :orden_trabajo_listas, :campo1, :estado_interno
  end
end
