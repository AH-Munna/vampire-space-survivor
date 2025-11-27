extends CanvasLayer

signal start_game
signal debug_sprites

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Ensure game is paused initially
	get_tree().paused = true

func _on_start_button_pressed() -> void:
	emit_signal("start_game")
	hide()
	get_tree().paused = false

func _on_debug_button_pressed() -> void:
	emit_signal("debug_sprites")

