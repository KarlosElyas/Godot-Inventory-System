extends PanelContainer
#SCRIPT da cena slot, para instanciar a UI dos slots do inventario

signal slot_clicked(index: int, button: int)

@onready var texture_rect = $MarginContainer/TextureRect
@onready var quantity_label = $QuantityLabel

func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data # referencia pro item do slot
	texture_rect.texture = item_data.texture
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	
	if slot_data.quantity > 1:
		quantity_label.text = "x%s" % slot_data.quantity
		quantity_label.show() # por padrão inativo/escondido
	else:
		quantity_label.hide()

# se clicar no slot, ele emit o sinal com index dele e do mouse button
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and (event.button_index == MOUSE_BUTTON_LEFT \
	or event.button_index == MOUSE_BUTTON_RIGHT) \
	and event.is_pressed():
		slot_clicked.emit(get_index(), event.button_index)