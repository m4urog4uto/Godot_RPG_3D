extends CharacterBody3D

var attackRate : float = .3
var lastAttackTime : int = 0
var damage: int = 1

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var sens := .05

var curHp = 10.0
var maxHP = 10.0

@onready var cam = $Pivote
@onready var attackCast = $AttackRayCast
@onready var ui = $CanvasLayer/UI


var gold = 0

'''
	usamos la función ready, que se ejecuta cuando el juego comienza,
	esto para desaparecer el puntero del mouse.
'''
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ui.update_gold_text(gold)
	ui.update_health_bar(curHp, maxHP)
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		try_attack()

func try_attack():
	if Time.get_ticks_msec() - lastAttackTime < attackRate * 1000:
		return 
	lastAttackTime = Time.get_ticks_msec()
	
	$WeaponHolder/SwordAnimator.stop()
	$WeaponHolder/SwordAnimator.play("attack")
	
	if attackCast.is_colliding():
		if attackCast.get_collider().has_method("take_damage"):
			attackCast.get_collider().take_damage(damage)

'''
	a diferencia de _process, _physics_process(delta) se usa para todo lo relacionado con la
	simulación de física o lógica que requiere consistencia temporal.
'''
func _physics_process(delta: float) -> void:
	movement(delta)
	move_and_slide()

# mover con el mouse
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# aca rotamos al personaje
		rotate_y(deg_to_rad(-event.relative.x * sens))
		
		# aca rotamos la camara
		cam.rotate_x(deg_to_rad(-event.relative.y * sens))
		# El clamp sirve para limitar  el movimiento de la camara al rotarla.
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-90), deg_to_rad(45))

# movimiento del jugador
func movement(delta:float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	'''
		Para agregar WASD, hay que ir hasta Project, Project Settings, 
		Input Map, y en el campo que dice Add New Action debemos colocar la refencia
		a la tecla que queremos y luego de agregarlo, le damos al + y buscamos la que 
		le corresponde
	'''
	var input_dir := Input.get_vector("d", "a", "s", "w")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

func give_gold(goldToGive):
	gold += goldToGive
	ui.update_gold_text(gold)

func take_damage(damage):
	curHp -= damage
	ui.update_health_bar(curHp, maxHP)
	
	if curHp <= 0:
		die()
		
func die():
	get_tree().reload_current_scene()

	
