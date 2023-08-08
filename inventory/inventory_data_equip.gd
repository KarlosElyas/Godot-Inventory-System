extends InventoryData
class_name InventoryDataEquip # este inventario tem 1 posição apenas

func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	#se não for equipavel retorna o item sem colocar no index
	if not grabbed_slot_data.item_data is ItemDataEquip:
		return grabbed_slot_data
	
	print("%s Armadura: %s" % [grabbed_slot_data.item_data.name,
	grabbed_slot_data.item_data.defence])
	return super.drop_slot_data(grabbed_slot_data, index)

func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	if not grabbed_slot_data.item_data is ItemDataEquip:
		return grabbed_slot_data
	
	return super.drop_single_slot_data(grabbed_slot_data, index)
