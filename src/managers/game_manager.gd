extends Node

signal hp_changed(new_hp)
signal xp_changed(new_xp, max_xp)
signal level_changed(new_level)
signal game_over

var hp: int = 10
var max_hp: int = 10
var xp: int = 0
var max_xp: int = 5 # Initial XP to level up
var level: int = 1
var time_elapsed: float = 0.0
var is_game_over: bool = false

func _process(delta: float) -> void:
	if not is_game_over:
		time_elapsed += delta

func take_damage(amount: int) -> void:
	if is_game_over: return
	
	hp -= amount
	hp_changed.emit(hp)
	
	if hp <= 0:
		game_over.emit()
		is_game_over = true
		# Simple restart for now or show game over screen
		# For now, just print
		print("Game Over")

func add_xp(amount: int) -> void:
	if is_game_over: return
	
	xp += amount
	if xp >= max_xp:
		level_up()
	
	xp_changed.emit(xp, max_xp)

func level_up() -> void:
	xp -= max_xp
	level += 1
	max_xp = int(max_xp * 1.5) # Increase XP requirement
	level_changed.emit(level)
	# TODO: Pause and show upgrade menu
	print("Level Up! New Level: ", level)

func reset_game() -> void:
	hp = max_hp
	xp = 0
	max_xp = 5
	level = 1
	time_elapsed = 0.0
	is_game_over = false
	hp_changed.emit(hp)
	xp_changed.emit(xp, max_xp)
	level_changed.emit(level)
