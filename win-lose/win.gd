extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var start_button: Button = $ui/start  # Ajustamos la referencia al botón "start"
@onready var salir_button: Button = $ui/salir  # Ajustamos la referencia al botón "salir"
@onready var close_curtain: Sprite2D = $CloseCurtain  # El Sprite de la cortina

func _ready() -> void:
	# Reproducir la animación de la transición
	animation_player.play("transicion")

func _on_salir_pressed() -> void:
	# Acción cuando el botón "Salir" es presionado
	get_tree().quit()

func _on_start_pressed() -> void:
	# Acción cuando el botón "Start" es presionado
	get_tree().change_scene_to_file("res://lore_intro/lore_intro.tscn")
