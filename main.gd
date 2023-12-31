extends Node
#cena PRINCIPAL vai fazer a ligação da DATA do player com a UI

const PickUp = preload("res://item/pick_up/pick_up.tscn")

@onready var hot_bar_inventory = $UI/HotBarInventory
@onready var player = $Player
@onready var inventory_interface = $UI/InventoryInterface
#OBSERVE que InventoryInterface NÃO é o inventario do player e sim um
# inventario GERAL que possui todos os demais

func _ready(): # o invetory_data Lógico do player é passado para a UI
	#conecta MANUALMENTE o sinal do player com a função toggle abaixo
	player.toggle_inventory.connect(toggle_inventory_interface)#.bind())
	inventory_interface.set_player_invetory_data(player.inventory_data)
	inventory_interface.set_equip_invetory_data(player.equip_inventory_data)
	inventory_interface.force_close.connect(toggle_inventory_interface)
	hot_bar_inventory.set_inventory_data(player.inventory_data)
	
	#todos os nodes que fazem parte de external_inventory são conectados
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)

func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = !inventory_interface.visible
	
	
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
		hot_bar_inventory.hide() # esconde o hotbar
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		hot_bar_inventory.show()
	
	# quando INTERAGE com o BAÚ ele emit o sinal PASSANDO ELE COMO ARGUMENTO
	if external_inventory_owner != null and inventory_interface.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else: # caso so abra o inventario ele retira a UI do baú
		inventory_interface.clear_external_inventory()
		#print("passou aqui")


func _on_inventory_interface_drop_slot_data(slot_data):
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data #grabbed_slot_data
	pick_up.position = player.get_drop_position()
	add_child(pick_up)
