extends CharacterBody2D

@export var fall_speed: float = 10.0  # Ajustar la velocidad de caída
@export var wave_amplitude: float = 4.0  # Ajustar la oscilación
@export var wave_frequency: float = 1.0  # Ajustar la frecuencia

var elapsed_time: float = 0.0
var time_offset: float = 0.0  # Para desincronizar hojas

func _ready() -> void:
	# Desfase aleatorio para cada instancia
	time_offset = randf_range(0, 2 * PI)

func _physics_process(delta: float) -> void:
	elapsed_time += delta

	# Movimiento sinusoidal
	var horizontal_displacement = wave_amplitude * sin((elapsed_time + time_offset) * wave_frequency)
	var vertical_displacement = fall_speed * delta

	# Mover la hoja
	position += Vector2(horizontal_displacement, vertical_displacement)
