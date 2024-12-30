extends Node2D

@onready var animation_player = $AnimationPlayer

# Se llama cuando el nodo entra en la escena.
# Se llama cuando el nodo entra en la escena.
func _ready() -> void:
	animation_player.play("fondito")
	# Conecta la señal "animation_finished" al método "_on_animation_finished"
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

# Método que se ejecuta cuando una animación termina.
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "fondito":
		animation_player.play("fondito2")
	elif anim_name == "fondito2":
		_change_scene()

# Cambiar a otra escena.
func _change_scene() -> void:
	get_tree().change_scene_to_file("res://level1/level1.tscn")
