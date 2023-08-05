extends PanelContainer
# SCRIPT do inventário, limpa e popula o invetário de acordo com a data
#do player, assim a Interface Gráfica exibira os itens de acordo com a data
const Slot = preload("res://inventory/slot.tscn")#cena do slot

@onready var item_grid = $MarginContainer/ItemGrid



func populate_item_grid(slot_datas: Array[SlotData]) -> void:
	for child in item_grid.get_children():
		child.queue_free()
	
	for slot_data in slot_datas:
		var slot = Slot.instantiate()
		item_grid.add_child(slot) # adicionando os slots do vetor no grid da UI
		
		if slot_data: # cria o slot com base no vetor
			slot.set_slot_data(slot_data)
