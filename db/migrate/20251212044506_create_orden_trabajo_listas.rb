class CreateOrdenTrabajoListas < ActiveRecord::Migration[8.0]
  def change
    create_table :orden_trabajo_listas do |t|
      t.references :orden_trabajo, null: false, foreign_key: true
      t.string :lista, null: false

      # Campos extra (1 a 22)
      (1..22).each do |i|
        t.string :"campo#{i}"
      end

      # Fecha de cada lista
      t.date :fecha_list

      # Posición dentro de la lista (para el drag & drop)
      t.integer :position

      t.timestamps
    end

    add_index :orden_trabajo_listas, [:orden_trabajo_id, :lista], unique: true
  end
end
