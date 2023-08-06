extends Resource
class_name SlotData

const MAX_STACK_SIZE: int = 99

@export var item_data: ItemData
@export_range(1, MAX_STACK_SIZE) var quantity: int = 1: set = set_quantity
# o valor atribuido vai para a função set_quantity e só então é definido

func can_fully_merge_with(other_slot_data: SlotData) -> bool:
	return item_data == other_slot_data.item_data and item_data.stackable \
	and quantity + other_slot_data.quantity <= MAX_STACK_SIZE

func can_merge_with(other_slot_data: SlotData) -> bool:
	return item_data == other_slot_data.item_data and item_data.stackable \
	and quantity < MAX_STACK_SIZE # se a quantidade for menor então pode aceitar mais 1

func fully_merge_with(other_slot_data: SlotData) -> void:
	quantity += other_slot_data.quantity

func create_single_slot_data() -> SlotData:
	var new_slot_data = duplicate() # duplica o atual
	new_slot_data.quantity = 1
	quantity -= 1 #decrementa a quantidade do atual
	return new_slot_data

func set_quantity(value: int) -> void:
	quantity = value
	if quantity > 1 and not item_data.stackable:
		quantity = 1
		push_error("%s não pode ser stackado, quantidade definida para 1" % item_data.name)
