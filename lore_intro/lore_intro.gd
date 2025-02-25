extends Node2D

@onready var animation_player = $AnimationPlayer

# Se llama cuando el nodo entra en la escena.
# Se llama cuando el nodo entra en la escena.
func _ready() -> void:
	animation_player.play("fondito")
	# Conecta la señal "animation_finished" al método "_on_animation_finished"
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
	var rich_text_label = $ui/texto # Asegúrate de que el nodo esté correctamente referenciado
	rich_text_label.text = "[color=#010106]El viento te trajo hasta acá. Antes, el mundo era un lugar verde y lleno de vida. Ahora, solo queda polvo y silencio.
Sos la última semilla viva, pequeña pero valiente. Si te detenés, serás parte del olvido. Pero si avanzás, si encontrás tierra fértil, podés hacer que todo vuelva a empezar.
No va a ser fácil, el suelo resquebrajado dificulta tu avance, el viento intenta arrastrarte, las aves no distinguen entre vos y su alimento.
Cada estación traerá nuevas pruebas, pero también esperanza.
Saltá, esquivá, resistí. Tu viaje comienza hoy…
[/color]"

# Método que se ejecuta cuando una animación termina.
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "fondito":
		animation_player.play("fondito2")
	elif anim_name == "fondito2":
		_change_scene()

# Cambiar a otra escena.
func _change_scene() -> void:
	get_tree().change_scene_to_file("res://level1/level1.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level1/level1.tscn")

	
