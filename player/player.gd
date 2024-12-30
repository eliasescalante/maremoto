extends CharacterBody2D

@export var speed: float = 200  # Velocidad de movimiento
@export var jump_strength: float = 400  # Fuerza del salto

@onready var sprite = $Sprite2D/AnimatedSprite2D  # Referencia al nodo AnimatedSprite2D
@onready var camera = $Camera2D  # Referencia al nodo Camera2D

# Variable que guarda la animación de idle por defecto
var idle_animation : String = "idle_right"

func _ready() -> void:
	if camera:
		camera.make_current()  # Activar esta cámara como la principal

	# Establecer la animación inicial
	sprite.play(idle_animation)

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	
	# Detectar movimiento a la derecha o izquierda
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		if is_on_floor() and sprite.animation != "walk_right":  # Solo cambia si no está en la animación correcta
			sprite.play("walk_right")  # Animación de caminar a la derecha
		# Cambiar la animación idle a la derecha
		idle_animation = "idle_right"

	elif Input.is_action_pressed("ui_left"):
		direction.x -= 1
		if is_on_floor() and sprite.animation != "walk_left":  # Solo cambia si no está en la animación correcta
			sprite.play("walk_left")  # Animación de caminar a la izquierda
		# Cambiar la animación idle a la izquierda
		idle_animation = "idle_left"

	# Si no hay movimiento horizontal, poner animación idle según la dirección
	if direction.x == 0:
		if sprite.animation != idle_animation:
			sprite.play(idle_animation)  # Cambiar la animación idle dependiendo de la dirección

	# Control de la velocidad
	velocity.x = direction.x * speed  # Movimiento horizontal

	# Salto
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = -jump_strength
		sprite.play("jump")  # Animación de salto

	# Gravedad
	if not is_on_floor():
		velocity.y += 1000 * delta  # Aumenta la gravedad mientras no está en el suelo

	# Mover al personaje
	move_and_slide()

	# Detener la animación de salto cuando llegue al suelo
	if is_on_floor() and !sprite.is_playing():
		# Si no está en una animación y no se mueve, vuelve a "idle"
		if direction.x == 0:
			sprite.play(idle_animation)  # Vuelve a la animación idle según la dirección
