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
		
	slot_datas[index] = grabbed_slot_data
	inventory_updated.emit(self)
	if slot_data: # se ja tive item na posição então retorna ele
		return slot_data
	else:
		return null

# a instancia do slot tem seu Sinal associado com esta função
func on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)
	#print("%s %s " % [index, button])
