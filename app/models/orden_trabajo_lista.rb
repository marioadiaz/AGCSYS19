class OrdenTrabajoLista < ApplicationRecord
  self.table_name = "orden_trabajo_listas"

  belongs_to :orden_trabajo
  validates :lista, presence: true

  default_scope { order(:position) }
  CAMPOS_EDITABLES = {
    "Cortadora de Bobinas" => [
      { atributo: :estado_interno, etiqueta: "Estado Interno", tipo: :text },
      { atributo: :observaciones, etiqueta: "Cant. Pliegos, Corte, Medida, Gramaje, Marca", tipo: :text },
      { atributo: :fecha_interna, etiqueta: "Fecha Interna", tipo: :date }
    ],

    "Laminadora Automática" => [
      { atributo: :estado_interno, etiqueta: "Estado Interno", tipo: :text },
      { atributo: :observaciones, etiqueta: "Tipo de laminado / Tamaño de pliego", tipo: :text },
      { atributo: :fecha_interna, etiqueta: "Fecha Interna", tipo: :date }
    ],

    "Laminadora Manual" => [
      { atributo: :estado_interno, etiqueta: "Estado Interno", tipo: :text },
      { atributo: :observaciones, etiqueta: "Tipo de laminado / Tamaño de pliego", tipo: :text },
      { atributo: :fecha_interna, etiqueta: "Fecha Interna", tipo: :date }
    ],

    "Tareas Manuales" => [
      { atributo: :estado_interno, etiqueta: "Estado Interno", tipo: :text },
      { atributo: :observaciones, etiqueta: "Tareas", tipo: :text },
      { atributo: :fecha_interna, etiqueta: "Fecha Interna", tipo: :date }
    ],

    "Binder" => [
      { atributo: :estado_interno, etiqueta: "Estado Interno", tipo: :text },
      { atributo: :cantidad, etiqueta: "Cantidad", tipo: :text },
      { atributo: :observaciones, etiqueta: "Observaciones / Fecha entrega", tipo: :text },
      { atributo: :fecha_interna, etiqueta: "Fecha Interna", tipo: :date }
    ],

    "Encuadernación" => [
      { atributo: :estado_interno, etiqueta: "Estado Interno", tipo: :text },
      { atributo: :cantidad, etiqueta: "Cantidad", tipo: :text },
      { atributo: :observaciones, etiqueta: "Observaciones / Fecha entrega", tipo: :text },
      { atributo: :fecha_interna, etiqueta: "Fecha Interna", tipo: :date }
    ],

    "Zechini" => [
      { atributo: :estado_interno, etiqueta: "Estado Interno", tipo: :text },
      { atributo: :cantidad, etiqueta: "Cantidad", tipo: :text },
      { atributo: :observaciones, etiqueta: "Observaciones / Fecha entrega", tipo: :text },
      { atributo: :fecha_interna, etiqueta: "Fecha Interna", tipo: :date }
    ],

    "Horda" => [
      { atributo: :estado_interno, etiqueta: "Estado Interno", tipo: :text },
      { atributo: :cantidad, etiqueta: "Cantidad", tipo: :text },
      { atributo: :observaciones, etiqueta: "Observaciones / Fecha entrega", tipo: :text },
      { atributo: :fecha_interna, etiqueta: "Fecha Interna", tipo: :date }
    ],

    "Perforadora Manual" => [
      { atributo: :estado_interno, etiqueta: "Estado Interno", tipo: :text },
      { atributo: :cantidad, etiqueta: "Cantidad", tipo: :text },
      { atributo: :observaciones, etiqueta: "Tipo de perforación", tipo: :text },
      { atributo: :fecha_interna, etiqueta: "Fecha Interna", tipo: :date }
    ],

    "Perforadora Automática" => [
      { atributo: :estado_interno, etiqueta: "Estado Interno", tipo: :text },
      { atributo: :cantidad, etiqueta: "Cantidad", tipo: :text },
      { atributo: :observaciones, etiqueta: "Tipo de perforación", tipo: :text },
      { atributo: :fecha_interna, etiqueta: "Fecha Interna", tipo: :date }
    ],

    "Anilladora Automática" => [
      { atributo: :estado_interno, etiqueta: "Estado Interno", tipo: :text },
      { atributo: :cantidad, etiqueta: "Cantidad", tipo: :text },
      { atributo: :observaciones, etiqueta: "Tipo de perforación", tipo: :text },
      { atributo: :fecha_interna, etiqueta: "Fecha Interna", tipo: :date }
    ],

    "Anilladora Manual" => [
      { atributo: :estado_interno, etiqueta: "Estado Interno", tipo: :text },
      { atributo: :cantidad, etiqueta: "Cantidad", tipo: :text },
      { atributo: :observaciones, etiqueta: "Tipo de perforación", tipo: :text },
      { atributo: :fecha_interna, etiqueta: "Fecha Interna", tipo: :date }
    ]
  }.freeze

  def self.campos_editables_para(lista)
    CAMPOS_EDITABLES.fetch(
      lista,
      [
        { atributo: :estado_interno, etiqueta: "Estado Interno", tipo: :text },
        { atributo: :observaciones, etiqueta: "Observaciones / Fecha entrega", tipo: :text },
        { atributo: :fecha_interna, etiqueta: "Fecha Interna", tipo: :date }
      ]
    )
  end
end
