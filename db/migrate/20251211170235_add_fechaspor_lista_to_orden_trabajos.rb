class AddFechasporListaToOrdenTrabajos < ActiveRecord::Migration[8.0]
  def change
    add_column :orden_trabajos, :fecha_ctp, :date
    add_column :orden_trabajos, :fecha_cortadora_bobinas, :date
    add_column :orden_trabajos, :fecha_guillotina_impresion, :date
    add_column :orden_trabajos, :fecha_pm, :date
    add_column :orden_trabajos, :fecha_sm5, :date
    add_column :orden_trabajos, :fecha_sm4, :date
    add_column :orden_trabajos, :fecha_gto_quick, :date
    add_column :orden_trabajos, :fecha_sorz, :date
    add_column :orden_trabajos, :fecha_guillotina_terminacion, :date
    add_column :orden_trabajos, :fecha_digital, :date
    add_column :orden_trabajos, :fecha_laminadora_automatica, :date
    add_column :orden_trabajos, :fecha_laminadora_manual, :date
    add_column :orden_trabajos, :fecha_barnizadora, :date
    add_column :orden_trabajos, :fecha_minerva_grande, :date
    add_column :orden_trabajos, :fecha_minerva_chica, :date
    add_column :orden_trabajos, :fecha_plana, :date
    add_column :orden_trabajos, :fecha_eterna, :date
    add_column :orden_trabajos, :fecha_tareas_manuales, :date
    add_column :orden_trabajos, :fecha_dobladora, :date
    add_column :orden_trabajos, :fecha_horizon, :date
    add_column :orden_trabajos, :fecha_fidia, :date
    add_column :orden_trabajos, :fecha_duplo, :date
    add_column :orden_trabajos, :fecha_binder, :date
    add_column :orden_trabajos, :fecha_encuadernacion, :date
    add_column :orden_trabajos, :fecha_zechini, :date
    add_column :orden_trabajos, :fecha_perforadora, :date
    add_column :orden_trabajos, :fecha_anilladora_automatica, :date
    add_column :orden_trabajos, :fecha_anilladora_manual, :date
    add_column :orden_trabajos, :fecha_mantenimiento, :date
  end
end
