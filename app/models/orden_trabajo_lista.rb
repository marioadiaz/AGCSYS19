class OrdenTrabajoLista < ApplicationRecord
  self.table_name = "orden_trabajo_listas"

  belongs_to :orden_trabajo
  validates :lista, presence: true

  default_scope { order(:position) }
end
