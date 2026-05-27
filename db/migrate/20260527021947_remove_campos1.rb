class RemoveCampos1 < ActiveRecord::Migration[8.0]
  def change
    remove_column :orden_trabajos, :campo1
    remove_column :orden_trabajos, :campo2
    remove_column :orden_trabajos, :fecha_jt
    remove_column :orden_trabajos, :fecha_ctp
    remove_column :orden_trabajos, :fecha_cortadora_bobinas
    remove_column :orden_trabajos, :fecha_guillotina_impresion
    remove_column :orden_trabajos, :fecha_pm
    remove_column :orden_trabajos, :fecha_sm5
    remove_column :orden_trabajos, :fecha_sm4
    remove_column :orden_trabajos, :fecha_gto_quick
    remove_column :orden_trabajos, :fecha_sorz
    remove_column :orden_trabajos, :fecha_guillotina_terminacion
    remove_column :orden_trabajos, :fecha_digital
    remove_column :orden_trabajos, :fecha_laminadora_automatica
    remove_column :orden_trabajos, :fecha_laminadora_manual
    remove_column :orden_trabajos, :fecha_barnizadora
    remove_column :orden_trabajos, :fecha_minerva_grande
    remove_column :orden_trabajos, :fecha_minerva_chica
    remove_column :orden_trabajos, :fecha_plana
    remove_column :orden_trabajos, :fecha_eterna
    remove_column :orden_trabajos, :fecha_tareas_manuales
    remove_column :orden_trabajos, :fecha_dobladora
    remove_column :orden_trabajos, :fecha_horizon
    remove_column :orden_trabajos, :fecha_fidia
    remove_column :orden_trabajos, :fecha_duplo
    remove_column :orden_trabajos, :fecha_binder
    remove_column :orden_trabajos, :fecha_encuadernacion
    remove_column :orden_trabajos, :fecha_zechini
    remove_column :orden_trabajos, :fecha_perforadora
    remove_column :orden_trabajos, :fecha_anilladora_automatica
    remove_column :orden_trabajos, :fecha_anilladora_manual
    remove_column :orden_trabajos, :fecha_mantenimiento    
  end
end

