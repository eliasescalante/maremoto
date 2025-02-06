extends CharacterBody2D

@export var speed: float = 200  # Velocidad base
@export var jump_strength: float = 700  # Fuerza del salto
@export var lose_scene: String = "res://lose.tscn"  # Escena de derrota

@onready var sprite = $Sprite2D/AnimatedSprite2D
@onready var camera = $Camera2D

var idle_animation: String = "idle_right"
var current_wind_force: float = 0.0  # Fuerza actual del viento

func _ready() -> void:
	if camera:
		camera.make_current()
	sprite.play(idle_animation)

# Método para añadir la fuerza del viento
func add_wind_force(force: float) -> void:
	current_wind_force = force

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO

	# Detectar movimiento a la derecha o izquierda
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		if is_on_floor() and sprite.animation != "walk_right":
			sprite.play("walk_right")
		idle_animation = "idle_right"

	elif Input.is_action_pressed("ui_left"):
		direction.x -= 1
		if is_on_floor() and sprite.animation != "walk_left":
			sprite.play("walk_left")
		idle_animation = "idle_left"

	# Animación idle cuando no hay movimiento horizontal
	if direction.x == 0:
		if sprite.animation != idle_animation:
			sprite.play(idle_animation)

	# Ajustar la velocidad del jugador por entrada del usuario
	velocity.x = direction.x * speed

	# Sumar el efecto del viento al movimiento horizontal
	velocity.x += current_wind_force

	# Salto
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = -jump_strength
		sprite.play("jump")

	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += 1000 * delta

	# Mover al jugador
	move_and_slide()

	# Detener la animación de salto cuando llega al suelo
	if is_on_floor() and not sprite.is_playing():
		if direction.x == 0:
			sprite.play(idle_animation)

func _on_fall_area_body_entered(body: Node) -> void:
	# Verificar si el cuerpo colisionado es el jugador
	if body == self:
		queue_free()  # Eliminar al jugador
		get_tree().change_scene(lose_scene)  # Cambiar a la escena de derrota
