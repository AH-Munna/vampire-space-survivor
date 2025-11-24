extends CanvasLayer

@onready var time_label: Label = $Control/TimeLabel
@onready var level_label: Label = $Control/LevelLabel
@onready var hp_label: Label = $Control/HPLabel
@onready var xp_bar: ProgressBar = $Control/XPBar

func _ready() -> void:
	# Connect to GameManager signals
	GameManager.hp_changed.connect(_on_hp_changed)
	GameManager.xp_changed.connect(_on_xp_changed)
	GameManager.level_changed.connect(_on_level_changed)
	
	# Initial update
	_on_hp_changed(GameManager.hp)
	_on_xp_changed(GameManager.xp, GameManager.max_xp)
	_on_level_changed(GameManager.level)

func _process(delta: float) -> void:
	# Update timer
	var minutes: int = int(GameManager.time_elapsed / 60)
	var seconds: int = int(GameManager.time_elapsed) % 60
	time_label.text = "%02d:%02d" % [minutes, seconds]

func _on_hp_changed(new_hp: int) -> void:
	hp_label.text = "HP: %d" % new_hp

func _on_xp_changed(new_xp: int, max_xp: int) -> void:
	xp_bar.max_value = max_xp
	xp_bar.value = new_xp

func _on_level_changed(new_level: int) -> void:
	level_label.text = "Level: %d" % new_level
