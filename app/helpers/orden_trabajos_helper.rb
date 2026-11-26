module OrdenTrabajosHelper
    
    def cadenatovector(cadena)
      return [] if cadena.blank?

      cadena
        .to_s
        .gsub(/[\[\]]/, "")
        .split(",")
        .map { |proceso| proceso.gsub(/\A['"]|['"]\z/, "").strip }
        .reject(&:blank?)
    end


    def cadenatohash(cadena)
      procesos_seleccionados = cadenatovector(cadena)

      OrdenTrabajo::POST.each_with_object({}) do |(clave, valor), resultado|
        resultado[clave] = valor if procesos_seleccionados.include?(valor)
      end
    end

    CAMPOS_FORM = {
      "CTP" => [
        [:fecha_ctp, "Fecha"]
      ],

      "Cortadora de Bobinas" => [
        [:campo1,  "Corte"],
        [:campo2,  "Medida y Gramaje"],
        [:campo3,  "Marca"],
        [:campo4,  "Peso I/Final"],
        [:fecha_cortadora_bobinas, "Fecha"]
      ],

      "Guillotina para Impresión" => [
        [:fecha_guillotina_impresion, "Fecha"]
      ],

      "PM" => [
        [:fecha_pm, "Fecha"]
      ],

      "SM 5 Cuerpos" => [
        [:fecha_sm5, "Fecha"]
      ],

      "SM 4 CUERPOS" => [
        [:fecha_sm4, "Fecha"]
      ],

      "GTO/QUICK" => [
        [:campo5,  "Maquina"],
        [:fecha_gto_quick, "Fecha"]
      ],

      "SORZ" => [
        [:fecha_sorz, "Fecha"]
      ],

      "Guillotina p/ Terminación" => [
        [:fecha_guillotina_terminacion, "Fecha"]
      ],

      "Digital" => [
        [:fecha_digital, "Fecha"]
      ],

      "Laminadora Automática" => [
        [:campo6,  "Laminado"],
        [:campo7,  "Pliego"],
        [:fecha_laminadora_automatica, "Fecha"]
      ],

      "Laminadora Manual" => [
        [:campo8,  "Laminado"],
        [:campo9,  "Pliego"],
        [:fecha_laminadora_manual, "Fecha"]
      ],

      "Barnizadora" => [
        [:fecha_barnizadora, "Fecha"]
      ],

      "Minerva Grande" => [
        [:campo10, "Tarea"],
        [:campo11, "Cod Troquel"],
        [:fecha_minerva_grande, "Fecha"]
      ],

      "Minerva Chica" => [
        [:campo12, "Tarea"],
        [:campo13, "Cod Troquel"],
        [:fecha_minerva_chica, "Fecha"]
      ],

      "Plana" => [
        [:campo14, "Tarea"],
        [:campo15, "Cod Troquel"],
        [:fecha_plana, "Fecha"]
      ],

      "Eterna" => [
        [:campo16, "Cod Troquel"],
        [:fecha_eterna, "Fecha"]
      ],

      "Tareas Manuales" => [
        [:campo17, "Tarea"],
        [:fecha_tareas_manuales, "Fecha"]
      ],

      "Dobladora" => [
        [:fecha_dobladora, "Fecha"]
      ],

      "Horizon" => [
        [:fecha_horizon, "Fecha"]
      ],

      "Fidia" => [
        [:fecha_fidia, "Fecha"]
      ],

      "Duplo" => [
        [:campo18, "Tarea"],
        [:fecha_duplo, "Fecha"]
      ],

      "Binder" => [
        [:fecha_binder, "Fecha"]
      ],

      "Encuadernación" => [
        [:campo19, "Tarea"],
        [:fecha_encuadernacion, "Fecha"]
      ],

      "Zechini" => [
        [:fecha_zechini, "Fecha"]
      ],

      "Perforadora" => [
        [:campo20, "Proceso"],
        [:campo21, "Maquina"],
        [:fecha_perforadora, "Fecha"]
      ],

      "Anilladora Automática" => [
        [:fecha_anilladora_automatica, "Fecha"]
      ],

      "Anilladora Manual" => [
        [:fecha_anilladora_manual, "Fecha"]
      ],

      "Tareas de Mantenimiento" => [
        [:campo22, "Responsable"],
        [:fecha_mantenimiento, "Fecha"]
      ]
    }.freeze
end

