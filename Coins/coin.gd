extends Area3D


@export var goldToGive : int = 1
var rotateSpeed : float = 5.0

func _process(delta: float) -> void:
	rotate_y(rotateSpeed * delta)


func _on_body_entered(body: Node3D) -> void:
	# Chequeamos si colisionamos con un player
	if body.name == "Player":
		'''
			Si se cumple, llamamos al metodo give_gold del jugador
			para pasarle por parametro el oro que da
		'''
		body.give_gold(goldToGive)
		print(body.gold)
		# Una vez que damos el oro, lo eliminamos del mapa.
		queue_free()
