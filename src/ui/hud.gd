extends CanvasLayer

@onready var xp_bar: ProgressBar = $Control/XPBar
@onready var hp_bar: ProgressBar = $Control/HPBar
@onready var level_label: Label = $Control/LevelLabel
@onready var time_label: Label = $Control/TimeLabel

var time_elapsed: float = 0.0

func _process(delta: float) -> void:
	time_elapsed += delta
	var minutes = int(time_elapsed / 60)
	var seconds = int(time_elapsed) % 60
	time_label.text = "%02d:%02d" % [minutes, seconds]

func update_hp(current: int, max_hp: int) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = current

func update_xp(current: int, max_xp: int) -> void:
	xp_bar.max_value = max_xp
	xp_bar.value = current

func update_level(level: int) -> void:
	level_label.text = "Level: " + str(level)
