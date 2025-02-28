extends Node2D

@export var wind_force: float = -100.0  # Fuerza del viento (hacia la izquierda)
@export var wind_duration: float = 3.0  # Duración del viento en segundos
@export var wind_interval: float = 6.0  # Intervalo entre ráfagas
@export var lose_scene: String = "res://lose.tscn"  # Ruta de la escena de derrota
@export var hoja_scene: PackedScene = preload("res://elementosDeNivel/piso_hoja.tscn")

@onready var spawn_area: Area2D = $ui/Area2D
@onready var player: Node2D = $ui/Player
@onready var wind_timer: Timer = $WindTimer
@onready var wind_audio: AudioStreamPlayer2D = $WindAudio  # Referencia al sonido de viento

var is_wind_active: bool = false
var wind_particles: Array = []  # Array de partículas de viento

func _ready() -> void:
	$StaticBody2D.connect("body_entered", Callable(self, "_on_area2d_body_entered"))

	if not wind_timer or not player or not wind_audio:
		push_error("Uno o más nodos no están correctamente configurados en la escena.")
		return

	# Llenar el array con las instancias de las partículas de viento
	for i in range(18):  # Asegurar que captura todas las partículas
		var wind_particle_instance = $ui/particulas.get_node_or_null("WindParticles" + str(i))
		if wind_particle_instance and wind_particle_instance is CPUParticles2D:
			wind_particles.append(wind_particle_instance)

	# Configurar el temporizador de viento
	wind_timer.wait_time = wind_interval
	wind_timer.one_shot = false
	wind_timer.start()

	# Conectar la señal "timeout" al método correspondiente
	wind_timer.connect("timeout", Callable(self, "_on_wind_timer_timeout"))
	
func _on_wind_timer_timeout() -> void:
	if not is_wind_active:
		is_wind_active = true

		# Activar todas las partículas del viento
		for wind_particle in wind_particles:
			wind_particle.emitting = true

		# Asegurar que el sonido del viento se reproduce en cada ráfaga
		if wind_audio:
			wind_audio.stop()  # Detener cualquier reproducción anterior para reiniciar correctamente
			wind_audio.play()

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
		player.add_wind_force(0.0)

func _on_area2d_body_entered(body: Node) -> void:
	if body == player:
		body.queue_free()
		get_tree().change_scene_to_file("res://win-lose/lose.tscn")

func _on_win_body_entered(body: Node2D) -> void:
	if body == player:
		print("¡Jugador ha llegado al final del nivel!")
		get_tree().change_scene_to_file("res://win-lose/win.tscn")
