extends Resource
class_name InventoryData

# como a Interface não conhece o InventoryData então vai como parametro
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)

@export var slot_datas: Array[SlotData]

# a instancia do slot tem seu Sinal associado com esta função
func on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)
	#print("%s %s " % [index, button])
