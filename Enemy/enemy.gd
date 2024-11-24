extends CharacterBody3D

var curHp : int = 3
var maxHp : int = 3

var damage : int = 1
var attackDist : float = 1.5
var attackRate : float = 1.0

var moveSpeed : float = 2.5

var vel : Vector3 = Vector3.ZERO

@onready var timer = $Timer
@onready var player = get_tree().get_nodes_in_group("Player")[0] as Node3D

func _ready() -> void:
	timer.wait_time = attackRate
	timer.start()

func _physics_process(_delta: float) -> void:
	# Aca obtenemos la distancia del enemigo con el jugador
	var dist = position.distance_to(player.position)
	
	# aca preguntamos si la distancia es mayor al ataque de distancia
	print(dist);
	if dist > attackDist:
		# aca cargamos en una variable la distancia del jugador menos la del enemigo
		# normalize lo que hace es normalizar la magnitud igual a 1
		var dir = (player.position - position).normalized()
		# aca le agregamos velocidad
		velocity.x = dir.x * moveSpeed
		velocity.y = 0
		velocity.z = dir.z * moveSpeed
	else:
		velocity = Vector3.ZERO
		
	# aca hacemos que se mueva
	move_and_slide()

func _on_timer_timeout() -> void:
	if global_transform.origin.distance_to(player.global_transform.origin) <= attackDist:
		player.take_damage(damage)
		
func take_damage(damage: int) -> void:
	curHp -= damage
	
	if curHp <= 0:
		die();

func die():
	queue_free()
