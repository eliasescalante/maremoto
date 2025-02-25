extends CharacterBody2D

# Velocidad de movimiento de la planta
@export var speed: float = 50.0

# Referencia al AnimatedSprite2D
@onready var animated_sprite = $AnimatedSprite2D

# Referencia al Area2D para detectar colisiones con el jugador
@onready var area2d = $Area2D

# Variable para controlar si la planta está activa
var is_active: bool = true

func _ready():
	# Conectar la señal de body_entered del Area2D
	area2d.body_entered.connect(_on_body_entered)

func _physics_process(delta):
	if is_active:
		# Mover la planta hacia la izquierda
		velocity.x = -speed
		move_and_slide()

		# Si la planta sale de la pantalla, la desactivamos
		if global_position.x < -100:  # Ajusta este valor según el tamaño de tu nivel
			queue_free()

func _on_body_entered(body):
	# Verificar si el cuerpo que colisionó es el jugador
	if body.name == "Player":  # Asegúrate de que el nombre del jugador sea "Player"
		# Lanzar la escena de derrota
		get_tree().change_scene_to_file("res://win-lose/lose.tscn")
