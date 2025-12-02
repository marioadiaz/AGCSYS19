require "application_system_test_case"

class OrdenTrabajosTest < ApplicationSystemTestCase
  setup do
    @orden_trabajo = orden_trabajos(:one)
  end

  test "visiting the index" do
    visit orden_trabajos_url
    assert_selector "h1", text: "Orden trabajos"
  end

  test "should create orden trabajo" do
    visit orden_trabajos_url
    click_on "New orden trabajo"

    fill_in "Cam10", with: @orden_trabajo.cam10
    fill_in "Cam12", with: @orden_trabajo.cam12
    fill_in "Cam24", with: @orden_trabajo.cam24
    fill_in "Campo1", with: @orden_trabajo.campo1
    fill_in "Campo2", with: @orden_trabajo.campo2
    fill_in "Campo3", with: @orden_trabajo.campo3
    fill_in "Campo4", with: @orden_trabajo.campo4
    fill_in "Campo5", with: @orden_trabajo.campo5
    fill_in "Campo6", with: @orden_trabajo.campo6
    fill_in "Campo7", with: @orden_trabajo.campo7
    fill_in "Campo8", with: @orden_trabajo.campo8
    fill_in "Cinom", with: @orden_trabajo.cinom
    fill_in "Colores", with: @orden_trabajo.colores
    fill_in "Deadline", with: @orden_trabajo.deadline
    check "Estado" if @orden_trabajo.estado
    fill_in "Estado actual", with: @orden_trabajo.estado_actual
    fill_in "Fecentr", with: @orden_trabajo.fecentr
    fill_in "Gramaje", with: @orden_trabajo.gramaje
    fill_in "Lista", with: @orden_trabajo.lista
    fill_in "Nomprod", with: @orden_trabajo.nomprod
    fill_in "Observaciones", with: @orden_trabajo.observaciones
    fill_in "Papel", with: @orden_trabajo.papel
    fill_in "Pliego", with: @orden_trabajo.pliego
    fill_in "Priority", with: @orden_trabajo.priority
    fill_in "Procesos", with: @orden_trabajo.procesos
    fill_in "Trcan", with: @orden_trabajo.trcan
    fill_in "Trcar", with: @orden_trabajo.trcar
    fill_in "Trnum", with: @orden_trabajo.trnum
    click_on "Create Orden trabajo"

    assert_text "Orden trabajo was successfully created"
    click_on "Back"
  end

  test "should update Orden trabajo" do
    visit orden_trabajo_url(@orden_trabajo)
    click_on "Edit this orden trabajo", match: :first

    fill_in "Cam10", with: @orden_trabajo.cam10
    fill_in "Cam12", with: @orden_trabajo.cam12
    fill_in "Cam24", with: @orden_trabajo.cam24
    fill_in "Campo1", with: @orden_trabajo.campo1
    fill_in "Campo2", with: @orden_trabajo.campo2
    fill_in "Campo3", with: @orden_trabajo.campo3
    fill_in "Campo4", with: @orden_trabajo.campo4
    fill_in "Campo5", with: @orden_trabajo.campo5
    fill_in "Campo6", with: @orden_trabajo.campo6
    fill_in "Campo7", with: @orden_trabajo.campo7
    fill_in "Campo8", with: @orden_trabajo.campo8
    fill_in "Cinom", with: @orden_trabajo.cinom
    fill_in "Colores", with: @orden_trabajo.colores
    fill_in "Deadline", with: @orden_trabajo.deadline
    check "Estado" if @orden_trabajo.estado
    fill_in "Estado actual", with: @orden_trabajo.estado_actual
    fill_in "Fecentr", with: @orden_trabajo.fecentr
    fill_in "Gramaje", with: @orden_trabajo.gramaje
    fill_in "Lista", with: @orden_trabajo.lista
    fill_in "Nomprod", with: @orden_trabajo.nomprod
    fill_in "Observaciones", with: @orden_trabajo.observaciones
    fill_in "Papel", with: @orden_trabajo.papel
    fill_in "Pliego", with: @orden_trabajo.pliego
    fill_in "Priority", with: @orden_trabajo.priority
    fill_in "Procesos", with: @orden_trabajo.procesos
    fill_in "Trcan", with: @orden_trabajo.trcan
    fill_in "Trcar", with: @orden_trabajo.trcar
    fill_in "Trnum", with: @orden_trabajo.trnum
    click_on "Update Orden trabajo"

    assert_text "Orden trabajo was successfully updated"
    click_on "Back"
  end

  test "should destroy Orden trabajo" do
    visit orden_trabajo_url(@orden_trabajo)
    click_on "Destroy this orden trabajo", match: :first

    assert_text "Orden trabajo was successfully destroyed"
  end
end
