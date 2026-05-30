class RenameCampo2ToObservacionesInOrdenTrabajoListas < ActiveRecord::Migration[8.0]
  def change
    rename_column :orden_trabajo_listas, :campo2, :observaciones
  end
end
