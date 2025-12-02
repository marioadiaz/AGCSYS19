class CreateOrdenTrabajos < ActiveRecord::Migration[8.0]
  def change
    create_table :orden_trabajos do |t|
      t.integer :trnum
      t.integer :trcan
      t.date :trcar
      t.string :clinom
      t.string :papel
      t.integer :gramaje
      t.string :colores
      t.integer :pliego
      t.string :nomprod
      t.date :fecentr
      t.string :cam10
      t.string :cam12
      t.string :cam24
      t.string :procesos
      t.string :observaciones
      t.string :estado_actual
      t.boolean :estado
      t.date :deadline
      t.string :priority
      t.string :lista
      t.string :campo1
      t.string :campo2
      t.string :campo3
      t.string :campo4
      t.string :campo5
      t.string :campo6
      t.string :campo7
      t.string :campo8
      t.integer :position

      t.timestamps
    end
  end
end
