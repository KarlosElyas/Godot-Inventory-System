extends CharacterBody3D
#SHIFT Alt O - Abrir rapidamente algo
@export var inventory_data: InventoryData #array de slots
@export var velocidade = 5
@export var pulo = 20
@export var sensibilidade = 0.002
const gravidade = 75
var health: int = 5
@onready var cabeca = $"Cabeça"
@onready var raycast = $"Cabeça/RayCast3D"
var target_velocity = Vector3.ZERO
var need = Necessidade.new(100.0, 0.1)
signal toggle_inventory()

func _ready():
	PlayerManager.player = self # Singleton/Estático
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	need.valor_atual = 0

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * sensibilidade) # aqui roda o eixo y
		cabeca.rotate_x(-event.relative.y * sensibilidade)
		cabeca.rotation.x = clamp(cabeca.rotation.x, -PI/2, PI/2)

func _unhandled_input(event):
	if is_on_floor() and event.is_action_pressed("pulo"):
		target_velocity.y = pulo
	if event.is_action_pressed("correr"):
	# o BUG acontece qnd se apertar mesmo sem correr ele gasta o NEED
		velocidade *= 1.5
		#if target_velocity.x != 0.0 || target_velocity.z != 0.0:
		need.queda *= 10
	elif event.is_action_released("correr"):
		velocidade /= 1.5
		need.queda /= 10
	#if event.is_action_just_pressed("inventory"):
	#event.is_action_just_pressed NÃO FUNCIONA
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
	if Input.is_action_just_pressed("interagir"):
		abrirPorta()
		interact()

func _process(_delta):
	$"../Seta".look_at($"Cabeça".get_global_transform().origin)#, transform.basis.y)

func _physics_process(delta):

	$"../ProgressBar".value = ceil(need.decrementar(need.queda * delta))
	if raycast.is_colliding():
		var alvo = raycast.get_collider()
		if alvo.is_in_group("bloco"):
			print_debug(alvo.name)
			$"../ProgressBar".value = need.incrementar(10.0)

	#abrirPorta()
	
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("direita"):
		direction.x += 1
	if Input.is_action_pressed("esquerda"):
		direction.x -= 1
	if Input.is_action_pressed("atras"):
		direction.z += 1
	if Input.is_action_pressed("frente"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized().rotated(Vector3.UP, rotation.y)
	if not is_on_floor():
		target_velocity.y -= gravidade * delta
	
	target_velocity.x = direction.x * velocidade
	target_velocity.z = direction.z * velocidade
	velocity = target_velocity
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_cancel"): #ESC
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

func abrirPorta():
	print(position.distance_to($"../RigidBody3D".position))
	if raycast.is_colliding():
		var alvo = raycast.get_collider()
		
		if alvo.get_parent().is_in_group("porta"):
			alvo.get_parent().abrir()

func interact() -> void:
	if raycast.is_colliding():
		var target = raycast.get_collider()
		if target.is_in_group("external_inventory"):
			raycast.get_collider().player_interact()

func get_drop_position() -> Vector3:
	var direction = -cabeca.global_transform.basis.z
	return cabeca.global_position + direction

func heal(heal_value: int) -> void:
	health += heal_value
