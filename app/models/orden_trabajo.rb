class OrdenTrabajo < ApplicationRecord
  # ----------------------------------------------------------------
  # 🔹 Validaciones básicas (aseguran calidad de datos importados)
  # ----------------------------------------------------------------
  has_many :orden_trabajo_listas, dependent: :destroy
  
  validates :clinom, presence: true
  validates :nomprod, presence: true
  validates :trcan, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  # ----------------------------------------------------------------
  # 🔹 Callbacks útiles
  # ----------------------------------------------------------------
  before_save :normalize_fields

  # ----------------------------------------------------------------
  # 🔹 Constantes
  # ----------------------------------------------------------------
  POST = [
    "SM","PM","GTO","QUICK","SORZ","Ko","Xe","Buv","Lam",
    "Tipografia","Fidia","Baum","Duplo","C.Hilo","Binder",
    "Zechini","Horda","Alzadora","C.Alambre","T.Manual","Otros","Guillotina","Renz"
  ].freeze

  LIST = [
    "CTP","Cortadora de Bobinas","Guillotina para Impresión","PM","SM 5 Cuerpos","SM 4 CUERPOS","GTO/QUICK","SORZ","Guillotina p/ Terminación",
    "Digital","Laminadora Automática","Laminadora Manual","Barnizadora","Minerva Grande","Minerva Chica",
    "Plana","Eterna","Tareas Manuales","Dobladora Baum","Dobladora Horizon","Fidia","Duplo","Binder","Encuadernación","Zechini","Horda","Perforadora Manual","Perforadora Automática","Anilladora Automática","Anilladora Manual","Tareas de Mantenimiento"
  ].freeze

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
  # ----------------------------------------------------------------
  # 🔹 Métodos de ayuda
  # ----------------------------------------------------------------

  # Devuelve una fecha legible para las vistas
  def formatted_deadline
    deadline&.strftime("%d/%m/%Y")
  end

  def formatted_trcar
    trcar&.strftime("%d/%m/%Y")
  end

  # ----------------------------------------------------------------
  # 🔹 Métodos privados
  # ----------------------------------------------------------------
  private

  # Normaliza texto para mantener consistencia
  def normalize_fields  
    self.papel   = papel.strip.titleize if papel.present?
  end
end
