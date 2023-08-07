extends Resource
class_name InventoryData

signal inventory_updated(inventory_data: InventoryData)
# como a Interface não conhece o InventoryData então vai como parametro
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)

@export var slot_datas: Array[SlotData] # VETOR DE SLOTS DATA

func grab_slot_data(index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	if slot_data: #caso na posição do index exista um slotdata 
		slot_datas[index] = null # ja esvazia a posição
		inventory_updated.emit(self) # recebido em populate do nó invetory
		return slot_data
	else:
		return null

func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index] # index do que foi clicado
	
	var return_slot_data: SlotData
	# caso o item possa MISTURAR então ele adiciona a quantidade
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		slot_datas[index] = grabbed_slot_data # passa o slot do grabbed
		return_slot_data = slot_data # caso seja null setara null
	
	inventory_updated.emit(self)
	return return_slot_data

func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	if slot_data == null:
		slot_datas[index] = grabbed_slot_data.create_single_slot_data()
	elif slot_data.can_merge_with(grabbed_slot_data): # se couber mais 1
		slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
	
	inventory_updated.emit(self)
	
	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else:
		return null

func use_slot_data(index: int) -> void:
	var slot_data = slot_datas[index]
	if not slot_data:
		return
	if slot_data.item_data is ItemDataConsumable:
		slot_data.quantity -= 1
		if slot_data.quantity < 1:
			slot_datas[index] = null
	
	#instancia singleton pois nao existe referencia por player
	PlayerManager.use_slot_data(slot_data)
	
	inventory_updated.emit(self)

func pick_up_slot_data(slot_data: SlotData) -> bool:
	# quando usa o .size() está acessando o indicie
	for index in slot_datas.size():
		if slot_datas[index] and slot_datas[index].can_fully_merge_with(slot_data):
			slot_datas[index].fully_merge_with(slot_data)
			inventory_updated.emit(self)
			return true
	
	for index in slot_datas.size():
		if slot_datas[index] == null:
			slot_datas[index] = slot_data
			inventory_updated.emit(self)
			return true
	
	return false

# a instancia do slot tem seu Sinal associado com esta função
func on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)
	#print("%s %s " % [index, button])
