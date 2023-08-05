extends Control
# SCRIPT do nó InventoryInterface em main

var grabbed_slot_data: SlotData
@onready var player_inventory = $PlayerInventory
@onready var grabbed_slot = $GrabbedSlot

func _physics_process(delta): # se o grabbed estiver visivel
	if grabbed_slot.visible:# então ele seguira a posição do mouse
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5.0, 5.0)

#função chamada pelo SCRIPT de Main
func set_player_invetory_data(inventory_data: InventoryData) -> void:
	# conecta o sinal de inventory data que vem como argumento
	inventory_data.inventory_interact.connect(on_inventory_interact)
	
	player_inventory.set_inventory_data(inventory_data)

# função chamada pelo sinal ao clicar no Slot.tscn
func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	#caso grabbed slot data seja null então entra no case ate atribuir um item a ele 
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:#se não tiver nada no slot e click direito
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		#CASO ja tenha um grabbed Slot
		[_, MOUSE_BUTTON_LEFT]: # _ underline pode significar qualquer coisa
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data ,index)
	
	update_grabbed_slot()

func update_grabbed_slot():
	if grabbed_slot_data: # define o nó grabbed slot com base no data
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()
