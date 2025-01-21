extends Node2D

@export var wind_force: float = -200.0  # Fuerza del viento (hacia la izquierda)
@export var wind_duration: float = 1.0  # Duración del viento en segundos
@export var wind_interval: float = 7.0  # Intervalo entre ráfagas
@export var lose_scene: String = "res://lose.tscn"  # Ruta de la escena de derrota

var is_wind_active: bool = false

@onready var player: Node2D = $ui/Player
@onready var wind_timer: Timer = $WindTimer

# Array de partículas de viento
@onready var wind_particles: Array = []

func _ready() -> void:
	$StaticBody2D.connect("body_entered", Callable(self, "_on_area2d_body_entered"))
	# Verificar que los nodos existen
	if not wind_timer or not player:
		push_error("Uno o más nodos no están correctamente configurados en la escena.")
		return

	# Llenar el array con las instancias de las partículas de viento
	for i in range(10):  # Suponiendo que deseas 10 partículas de viento
		var wind_particle_instance = $ui.get_node("WindParticles" + str(i))  # Ajusta el nombre del nodo según corresponda
		if wind_particle_instance and wind_particle_instance is CPUParticles2D:
			wind_particles.append(wind_particle_instance)

	# Configurar el temporizador para que sea cíclico
	wind_timer.wait_time = wind_interval
	wind_timer.one_shot = false  # Permitir que el temporizador siga repitiéndose
	wind_timer.start()

	# Conectar la señal "timeout" al método correspondiente
	wind_timer.connect("timeout", Callable(self, "_on_wind_timer_timeout"))

func _on_wind_timer_timeout() -> void:
	if not is_wind_active:
		is_wind_active = true
		
		# Activar todas las partículas del viento
		for wind_particle in wind_particles:
			wind_particle.emitting = true

		# Aplicar la fuerza del viento al jugador
		if player and player.has_method("add_wind_force"):
			player.add_wind_force(wind_force)

		# Crear un temporizador para la duración del viento
		var wind_duration_timer = Timer.new()
		wind_duration_timer.wait_time = wind_duration
		wind_duration_timer.one_shot = true
		add_child(wind_duration_timer)
		wind_duration_timer.start()

		# Conectar el temporizador de duración para detener el viento
		wind_duration_timer.connect("timeout", Callable(self, "_stop_wind"))

func _stop_wind() -> void:
	# Detener todas las partículas y desactivar el viento
	for wind_particle in wind_particles:
		wind_particle.emitting = false

	is_wind_active = false

	# Eliminar el efecto del viento en el jugador
	if player and player.has_method("add_wind_force"):
		player.add_wind_force(0.0)  # Restablecer la fuerza del viento a 0

func _on_area2d_body_entered(body: Node) -> void:
	# Verificar si el objeto que entra es el jugador
	if body == player:
		body.queue_free()  # Eliminar al jugador
		get_tree().change_scene_to_file("res://win-lose/lose.tscn")
