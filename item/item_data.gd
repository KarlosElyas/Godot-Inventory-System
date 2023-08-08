extends Resource
class_name ItemData

@export var name: String = ""
@export_multiline var description: String = ""
@export var stackable: bool = false
@export var texture: AtlasTexture

func use(_target) -> void:
	pass # função herdada para itens que podem ser usados
