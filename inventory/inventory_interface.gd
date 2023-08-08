extends Control
# SCRIPT do nó InventoryInterface em main
signal drop_slot_data(slot_data: SlotData)
signal force_close

var grabbed_slot_data: SlotData
var external_inventory_owner

@onready var player_inventory = $PlayerInventory
@onready var grabbed_slot = $GrabbedSlot
@onready var external_inventory = $ExternalInventory
@onready var equip_inventory = $EquipInventory

func _physics_process(_delta): # se o grabbed estiver visivel
	if grabbed_slot.visible:# então ele seguira a posição do mouse
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5.0, 5.0)
	
	#Fecha o inventario se estiver DISTANTE
	if external_inventory_owner and \
	external_inventory_owner.global_position.distance_to(PlayerManager.get_global_position()) > 4.0:
		force_close.emit()

#função chamada pelo SCRIPT de Main
func set_player_invetory_data(inventory_data: InventoryData) -> void:
	# conecta o sinal de inventory data que vem como argumento
	inventory_data.inventory_interact.connect(on_inventory_interact)
	#popula a grid do inventario Player
	player_inventory.set_inventory_data(inventory_data)

func set_equip_invetory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	equip_inventory.set_inventory_data(inventory_data)

func set_external_inventory(_external_inventory_owner) -> void:
	external_inventory_owner = _external_inventory_owner
	#obtém o data de inventario do baú
	var inventory_data = external_inventory_owner.inventory_data
	
	inventory_data.inventory_interact.connect(on_inventory_interact)
	external_inventory.set_inventory_data(inventory_data)
	external_inventory.show()

# Desconectando o inventario do baú
func clear_external_inventory() -> void:
	if external_inventory_owner:
		var inventory_data = external_inventory_owner.inventory_data
		
		inventory_data.inventory_interact.disconnect(on_inventory_interact)
		# disconectar o UPDATE do data com o populate da UI
		external_inventory.clear_inventory_data(inventory_data)
		
		external_inventory.hide()
		external_inventory_owner = null

# função chamada pelo sinal ao clicar no Slot.tscn
func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	#caso grabbed slot data seja null então entra no case ate atribuir um item a ele 
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:#se não tiver nada no slot e click direito
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		#CASO ja tenha um grabbed Slot
		[_, MOUSE_BUTTON_LEFT]: # _ underline pode significar qualquer coisa
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data ,index)
		[null, MOUSE_BUTTON_RIGHT]:
			inventory_data.use_slot_data(index)
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data ,index)
	
	update_grabbed_slot()

func update_grabbed_slot():
	if grabbed_slot_data: # define o nó grabbed slot com base no data
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()

func _on_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed() \
		and grabbed_slot_data:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				drop_slot_data.emit(grabbed_slot_data)
				grabbed_slot_data = null
			
			MOUSE_BUTTON_RIGHT:
				drop_slot_data.emit(grabbed_slot_data.create_single_slot_data())
				if grabbed_slot_data.quantity < 1:
					grabbed_slot_data = null
		
		update_grabbed_slot()


func _on_visibility_changed(): # se fechar o inventario segurando item
	if not visible and grabbed_slot_data:
		drop_slot_data.emit(grabbed_slot_data)
		grabbed_slot_data = null
		update_grabbed_slot()
