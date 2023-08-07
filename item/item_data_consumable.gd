extends ItemData
class_name  ItemDataConsumable

@export var heal_value: int
#exemplos apenas. poderia ter fome, energia, sede etc...

func use(target) -> void: # target PODE ser o PLAYER
	if heal_value != 0:
		target.heal(heal_value)
	#ai dependendo do item vai colocando os IFs com atributos aki
