extends Node3D

var isOpen = false

func abrir():
	if isOpen:
		$Pivot.rotation.y -= PI/2
		$portasom2.play()
	else:
		$Pivot.rotation.y += PI/2
		$portasom.play()
	isOpen = !isOpen # inverte o bool

func anim():
	$AnimationPlayer.play("porta_abrir")
	await get_tree().create_timer(5.0).timeout
	$AnimationPlayer.play("porta_fechar")


func _on_placa_pressao_body_entered(_body):
	anim()
