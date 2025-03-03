extends CharacterBody2D

@export var speed: float = 200.0  # Velocidad hacia la izquierda
@export var gravity: float = 980.0  # Gravedad simulada
@export var destruction_x_position: float = 200.0  # Posición X para destruir la planta

@onready var animated_sprite = $AnimatedSprite2D
@onready var area2d = $Area2D

var initial_position: Vector2  # Guarda la posición original
var is_active: bool = false  # Se activará cuando el jugador esté cerca

func _ready():
	initial_position = global_position  # Guarda la posición original
	animated_sprite.play("default")  # Reproduce animación inicial
	area2d.body_entered.connect(_on_body_entered)

	# Depuración
	print("Posición inicial de la planta:", initial_position)
	print("Capa de colisión de la planta:", collision_layer)
	print("Máscara de colisión de la planta:", collision_mask)

	# Configurar colisiones para detectar solo el StaticBody2D flotante
	collision_layer = 1  # Capa de la planta
	collision_mask = 2   # Solo colisiona con la capa 2 (StaticBody2D flotante)

func _physics_process(delta):
	if not is_active:
		_check_player_proximity()
		return  # No moverse si no está activada

	# Aplicar gravedad
	velocity.y += gravity * delta  

	# Movimiento lateral hacia la izquierda (velocidad en X)
	velocity.x = -speed  

	# Mover la planta con colisiones
	move_and_slide()  # Pasa velocity como argumento para que se mueva correctamente

	# Si la planta alcanza la posición X de destrucción, eliminarla
	if global_position.x < destruction_x_position:
		print("Planta alcanzó la posición de destrucción. Eliminando...")
		queue_free()  # Elimina la planta de la escena

func _on_body_entered(body):
	# Detectar colisión con el jugador
	if body.name == "Player":
		print("La planta tocó al jugador.")
		get_tree().change_scene_to_file("res://win-lose/lose.tscn")

func _check_player_proximity():
	var players = get_tree().get_nodes_in_group("player")
	
	if players.size() > 0:
		var player = players[0]  # Tomar el primer jugador encontrado
		var distance = global_position.distance_to(player.global_position)
		
		print("Distancia al jugador:", distance)  # DEPURACIÓN
		
		if distance < 200 and not is_active:  # Solo activar si no está ya activa
			print("¡Jugador cerca! Activando planta")
			is_active = true
