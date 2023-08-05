extends Node
#cena PRINCIPAL vai fazer a ligação da DATA do player com a UI

@onready var player = $Player
@onready var inventory_interface = $UI/InventoryInterface
#OBSERVE que InventoryInterface NÃO é o inventario do player e sim um
# inventario GERAL que possui todos os demais

func _ready(): # o invetory_data Lógico do player é passado para a UI
	#conecta MANUALMENTE o sinal do player com a função toggle abaixo
	player.toggle_inventory.connect(toggle_inventory_interface)#.bind())
	inventory_interface.set_player_invetory_data(player.inventory_data)

func toggle_inventory_interface() -> void:
	inventory_interface.visible = !inventory_interface.visible
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if inventory_interface.visible else Input.MOUSE_MODE_CAPTURED
