extends Node  #PlayeManager - Singleton do projeto

var player # variavel associada no ready() do player

func use_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.use(player)

func get_global_position() -> Vector3:
	return player.global_position
