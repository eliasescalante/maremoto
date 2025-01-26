extends CharacterBody2D

# Variables para el movimiento
@export var fall_speed: float = 10.0  # Velocidad de caída
@export var wave_amplitude: float = 6.0  # Amplitud del movimiento ondulante
@export var wave_frequency: float = 2.0  # Frecuencia del movimiento ondulante

var elapsed_time: float = 0.0  # Tiempo transcurrido
var time_offset: float = 0.0  # Desfase inicial del tiempo

func _ready() -> void:
	# Asignar un desfase aleatorio para desincronizar
	time_offset = randi() / 100.0  # Valor aleatorio entre 0 y 10 (ajústalo según la frecuencia)

func _physics_process(delta: float) -> void:
	# Incrementar el tiempo transcurrido
	elapsed_time += delta

	# Calcular el desplazamiento horizontal con un patrón sinusoidal
	var horizontal_displacement = wave_amplitude * sin((elapsed_time + time_offset) * wave_frequency)

	# Calcular el desplazamiento vertical (caída constante)
	var vertical_displacement = fall_speed * delta

	# Actualizar la posición del nodo
	position += Vector2(horizontal_displacement, vertical_displacement)

	# Verificar si la hoja está fuera de la vista de la cámara
	var viewport_rect = get_viewport_rect()
	var camera_rect = Rect2(get_viewport().get_camera_2d().global_position - viewport_rect.size / 2, viewport_rect.size)

	if position.y > camera_rect.position.y + camera_rect.size.y:
		# Reposicionar la hoja en un nuevo punto inicial fuera de la vista superior de la cámara
		position.y = camera_rect.position.y - 10
		position.x = camera_rect.position.x + fmod(float(randi()), camera_rect.size.x)
