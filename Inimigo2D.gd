extends CharacterBody2D

var velocidade = 300
var direcao = 1

func _physics_process(_delta):
	velocity.x = velocidade * direcao
	move_and_slide()
	
	if $RayCast2D.is_colliding():
		#print_debug("Colidiu")
		direcao *= -1
		$RayCast2D.scale.x *= -1

