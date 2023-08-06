extends PanelContainer
# SCRIPT do inventário, limpa e popula o invetário de acordo com a data
#do player, assim a Interface Gráfica exibira os itens de acordo com a data
const Slot = preload("res://inventory/slot.tscn")#cena do slot

@onready var item_grid = $MarginContainer/ItemGrid

func set_inventory_data(inventory_data: InventoryData) -> void:
	# conecta com o populate que ja recebe o data atualizado
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func clear_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.disconnect(populate_item_grid)

func populate_item_grid(inventory_data: InventoryData) -> void:
	for child in item_grid.get_children():
		child.queue_free()
	
	for slot_data in inventory_data.slot_datas:
		var slot = Slot.instantiate()
		item_grid.add_child(slot) # adicionando os slots do vetor no grid da UI
		
		#necessário pois slot é instanciado aqui (run time)
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		# NÃO ESTÁ chamando a função, APENAS CONECTANDO
		
		if slot_data: # cria o slot com base no vetor
			slot.set_slot_data(slot_data)
