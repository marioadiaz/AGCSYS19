document.addEventListener("turbo:load", () => {
  // Inicializar todos los selectpicker de la página
  $(".selectpicker").each(function() {
    const $select = $(this);
    const id = $select.attr("id") || "";
    const hiddenId = id.replace("orden_trabajo_procesos_", "hidden_procesos_");

    // 🔄 Destruye instancias previas (por Turbo)
    $select.selectpicker("destroy");

    // ✅ Inicializa el Bootstrap Select
    $select.selectpicker();
    

    // 🎯 Evento de cambio de selección
    $select.on("changed.bs.select", function() {
      const seleccion = $(this).val() || [];
      console.log("Procesos seleccionados:", seleccion);

      // Actualiza el campo oculto para enviarlo al servidor
      $("#" + hiddenId).val(seleccion.join(","));
    });
  });
});

// 🧹 Destruye antes de cachear con Turbo (evita duplicados)
document.addEventListener("turbo:before-cache", () => {
  $(".selectpicker").selectpicker("destroy");
});
