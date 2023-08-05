extends Control
# SCRIPT do nó InventoryInterface em main
@onready var player_inventory = $PlayerInventory

#função chamada pelo SCRIPT de Main
func set_player_invetory_data(inventory_data: InventoryData) -> void:
	# conecta o sinal de inventory data que vem como argumento
	inventory_data.inventory_interact.connect(on_inventory_interact)
	
	player_inventory.set_inventory_data(inventory_data)

func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	print("%s %s %s" % [inventory_data, index, button])
