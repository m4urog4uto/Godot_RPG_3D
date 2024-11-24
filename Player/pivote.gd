extends Node3D


#Stats de la camara
var lookSensitivity : float = 15.0
var minLookAngle : float = -20.0
var maxLookAngle : float = 75.0

#Vectores
var mouseDelta = Vector2()

#Componentes
@onready var player = get_parent()

#El evento input detecta el teclado, joystick o mouse
func _input(event: InputEvent) -> void:
	# Aca chequeamos si el evento es del tipo Mouse
	if event is InputEventMouseMotion:
		'''
			relative es la posición del ratón en 
			relación con la posición anterior (posición en el ultimo cadro).
		'''
		mouseDelta = event.relative

# La función process llama cada cuadro dentro del juego
func _process(delta: float) -> void:
	var rot = Vector3(mouseDelta.y, mouseDelta.x, 0) * lookSensitivity * delta
	
	# Aca hacemos referencia al pivote y modificamos la rotación
	rotation_degrees.x += rot.x
	rotation_degrees.x = clamp(rotation_degrees.x, minLookAngle, maxLookAngle)
	
	# Aca como hacemos referencia al jugador, lo movemos en conjunto
	player.rotation_degrees.y -= rot.y
	
	mouseDelta = Vector2()

# La función ready se ejecute cuando el nodo este listo
func _ready() -> void:
	# Aca se oculta el puntero dentro del juego.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
	
