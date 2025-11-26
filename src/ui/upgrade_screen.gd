extends CanvasLayer

signal upgrade_selected(type: String)

@onready var card_container: HBoxContainer = $Control/HBoxContainer
@onready var speed_card: Button = $Control/HBoxContainer/SpeedCard
@onready var spread_card: Button = $Control/HBoxContainer/SpreadCard
@onready var magnet_card: Button = $Control/HBoxContainer/MagnetCard

func _ready() -> void:
	# Pause game when this screen opens
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

func set_options(options: Array) -> void:
	# Hide all first
	for child in card_container.get_children():
		child.hide()
	
	if "max_hp" in options:
		speed_card.text = "Max HP\n+5"
		speed_card.show()
		if speed_card.is_connected("pressed", _on_speed_button_pressed):
			speed_card.pressed.disconnect(_on_speed_button_pressed)
		if not speed_card.is_connected("pressed", _on_max_hp_pressed):
			speed_card.pressed.connect(_on_max_hp_pressed)
			
	elif "homing" in options:
		speed_card.text = "Homing\nBullets"
		speed_card.show()
		if speed_card.is_connected("pressed", _on_speed_button_pressed):
			speed_card.pressed.disconnect(_on_speed_button_pressed)
		if not speed_card.is_connected("pressed", _on_homing_pressed):
			speed_card.pressed.connect(_on_homing_pressed)
			
	else:
		# Default: Show all 3 standard upgrades
		speed_card.text = "Fire Rate\n+10%"
		speed_card.show()
		if speed_card.is_connected("pressed", _on_max_hp_pressed):
			speed_card.pressed.disconnect(_on_max_hp_pressed)
		if speed_card.is_connected("pressed", _on_homing_pressed):
			speed_card.pressed.disconnect(_on_homing_pressed)
		if not speed_card.is_connected("pressed", _on_speed_button_pressed):
			speed_card.pressed.connect(_on_speed_button_pressed)
			
		spread_card.text = "Spread\n+1 Bullet"
		spread_card.show()
		
		magnet_card.text = "Magnet Area\n+35%"
		magnet_card.show()

func _on_magnet_button_pressed() -> void:
	emit_signal("upgrade_selected", "magnet")
	close()

func _on_max_hp_pressed() -> void:
	emit_signal("upgrade_selected", "max_hp")
	close()

func _on_homing_pressed() -> void:
	emit_signal("upgrade_selected", "homing")
	close()

func open() -> void:
	show()
	get_tree().paused = true

func close() -> void:
	hide()
	get_tree().paused = false

func _on_speed_button_pressed() -> void:
	emit_signal("upgrade_selected", "speed")
	close()

func _on_spread_button_pressed() -> void:
	emit_signal("upgrade_selected", "spread")
	close()
