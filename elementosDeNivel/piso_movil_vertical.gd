extends CharacterBody2D

# Variables exportadas para ajustar en el editor
@export var move_distance: float = 200.0 # Distancia en píxeles que recorrerá
@export var move_speed: float = 100.0 # Velocidad de movimiento en píxeles/segundo

# Variables internas
var direction: int # Dirección de movimiento (1 = derecha, -1 = izquierda)
var start_position: Vector2

func _ready():
	# Guarda la posición inicial del nodo
	start_position = position
	
	# Asigna una dirección inicial aleatoria (1 o -1)
	direction = 1 if randf() > 0.5 else -1

func _physics_process(delta: float) -> void:
	# Calcula el desplazamiento
	var offset = direction * move_speed * delta
	position.y += offset

	# Cambia de dirección si se pasa del rango permitido
	if position.y > start_position.y + move_distance:
		direction = -1
	elif position.y < start_position.y - move_distance:
		direction = 1
