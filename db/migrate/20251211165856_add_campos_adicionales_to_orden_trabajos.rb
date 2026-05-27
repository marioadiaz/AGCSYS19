class AddCamposAdicionalesToOrdenTrabajos < ActiveRecord::Migration[8.0]
  def change
    (9..22).each do |n|
      add_column :orden_trabajos, "campo#{n}", :string
    end  
  end
end
