class RemoveCampos < ActiveRecord::Migration[8.0]
  def change
    remove_column :orden_trabajos, :campo3
    remove_column :orden_trabajos, :campo4
    remove_column :orden_trabajos, :campo5
    remove_column :orden_trabajos, :campo6
    remove_column :orden_trabajos, :campo7
    remove_column :orden_trabajos, :campo8
    remove_column :orden_trabajos, :campo9
    remove_column :orden_trabajos, :campo10
    remove_column :orden_trabajos, :campo11
    remove_column :orden_trabajos, :campo12
    remove_column :orden_trabajos, :campo13
    remove_column :orden_trabajos, :campo14
    remove_column :orden_trabajos, :campo15
    remove_column :orden_trabajos, :campo16
    remove_column :orden_trabajos, :campo17
    remove_column :orden_trabajos, :campo18
    remove_column :orden_trabajos, :campo19
    remove_column :orden_trabajos, :campo20
    remove_column :orden_trabajos, :campo21
    remove_column :orden_trabajos, :campo22
  end
end
