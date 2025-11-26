extends Node

@export var enemy_scene: PackedScene = preload("res://src/actors/Enemy.tscn")
@export var spawn_rate: float = 2.0
@export var arena_width: int = 2304
@export var arena_height: int = 2304

var spawn_timer: float = 0.0
var current_level: int = 1

func _process(delta: float) -> void:
	# Gradual increase: 0.02 per second
	var reduction = 0.02 * delta
	
	# Level 10+ spike: Extra reduction
	if current_level >= 10:
		reduction += 0.05 * delta
		
	spawn_rate = max(0.1, spawn_rate - reduction)
	
	spawn_timer -= delta
	if spawn_timer <= 0.0:
		spawn_timer = spawn_rate
		spawn_enemy()

func on_level_up(level: int) -> void:
	current_level = level
	# Optional: Immediate difficulty bump on level up?
	# spawn_rate *= 0.95

func spawn_enemy() -> void:
	if not enemy_scene:
		return
		
	var enemy = enemy_scene.instantiate()
	var spawn_pos = Vector2.ZERO
	
	# Randomly pick a side: 0=Top, 1=Bottom, 2=Left, 3=Right
	var side = randi() % 4
	
	match side:
		0: # Top
			spawn_pos.x = randf_range(0, arena_width)
			spawn_pos.y = -50 # Slightly off-screen
		1: # Bottom
			spawn_pos.x = randf_range(0, arena_width)
			spawn_pos.y = arena_height + 50
		2: # Left
			spawn_pos.x = -50
			spawn_pos.y = randf_range(0, arena_height)
		3: # Right
			spawn_pos.x = arena_width + 50
			spawn_pos.y = randf_range(0, arena_height)
	
	enemy.global_position = spawn_pos
	
	# Add to Main scene (parent of this manager usually)
	# Or better, add to the root or a specific "Enemies" container if we had one.
	# For now, adding to the parent (Main) is fine.
	get_parent().add_child(enemy)
