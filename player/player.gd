extends CharacterBody2D

@export var speed: float = 200  # Velocidad base
@export var jump_strength: float = 700  # Fuerza del salto
@export var lose_scene: String = "res://lose.tscn"  # Escena de derrota

@onready var sprite = $Sprite2D/AnimatedSprite2D
@onready var camera = $Camera2D
@onready var footstep_audio = $FootstepAudio  # Referencia al sonido de pasos
@onready var wind_audio: AudioStreamPlayer2D = get_node("/root/Level1/WindAudio")  # Referencia al audio del viento

var idle_animation: String = "idle_right"
var current_wind_force: float = 0.0  # Fuerza actual del viento
var was_on_floor: bool = false  # Estado previo del jugador

func _ready() -> void:
	if camera:
		camera.make_current()
	sprite.play(idle_animation)

# Método para añadir la fuerza del viento
func add_wind_force(force: float) -> void:
	current_wind_force = force

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	var is_moving = false

	# Detectar movimiento a la derecha o izquierda
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		if is_on_floor():
			sprite.play("walk_right")
		idle_animation = "idle_right"
		is_moving = true

	elif Input.is_action_pressed("ui_left"):
		direction.x -= 1
		if is_on_floor():
			sprite.play("walk_left")
		idle_animation = "idle_left"
		is_moving = true

	# Animación idle cuando no hay movimiento horizontal
	if direction.x == 0:
		if sprite.animation != idle_animation:
			sprite.play(idle_animation)
		is_moving = false

	# Ajustar la velocidad del jugador por entrada del usuario
	velocity.x = direction.x * speed
	velocity.x += current_wind_force  # Sumar el efecto del viento

	# Salto
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = -jump_strength
		sprite.play("jump")
		_stop_footsteps()

	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += 1000 * delta

	# Mover al jugador
	move_and_slide()

	# Manejo del sonido de pasos con detección más robusta
	if is_on_floor():
		if is_moving:
			_play_footsteps()
		else:
			_stop_footsteps()
	else:
		_stop_footsteps()

	# Si el jugador cae de un objeto al suelo, reiniciamos el sonido correctamente
	if is_on_floor() and not was_on_floor:
		_play_footsteps()

	# Guardar el estado previo del jugador en el suelo
	was_on_floor = is_on_floor()

# Métodos para manejar el sonido de pasos
func _play_footsteps() -> void:
	if is_on_floor() and not footstep_audio.playing:
		footstep_audio.play()

func _stop_footsteps() -> void:
	if footstep_audio.playing:
		footstep_audio.stop()

func _on_fall_area_body_entered(body: Node) -> void:
	# Verificar si el cuerpo colisionado es el jugador
	if body == self:
		queue_free()  # Eliminar al jugador
		get_tree().change_scene(lose_scene)  # Cambiar a la escena de derrota
