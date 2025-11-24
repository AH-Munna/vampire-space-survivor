extends Node

@export var enemy_scene: PackedScene
@export var spawn_rate: float = 2.0

var spawn_timer: float = 0.0
var arena_rect: Rect2 = Rect2(0, 0, 1600, 900)

func _process(delta: float) -> void:
	if GameManager.is_game_over: return
	
	spawn_timer -= delta
	if spawn_timer <= 0.0:
		spawn_timer = spawn_rate
		spawn_enemy()

func spawn_enemy() -> void:
	if not enemy_scene: return
	
	var enemy = enemy_scene.instantiate()
	enemy.global_position = get_random_edge_position()
	add_child(enemy)

func get_random_edge_position() -> Vector2:
	var side = randi() % 4
	var pos = Vector2.ZERO
	
	match side:
		0: # Top
			pos.x = randf_range(0, arena_rect.size.x)
			pos.y = -50
		1: # Bottom
			pos.x = randf_range(0, arena_rect.size.x)
			pos.y = arena_rect.size.y + 50
		2: # Left
			pos.x = -50
			pos.y = randf_range(0, arena_rect.size.y)
		3: # Right
			pos.x = arena_rect.size.x + 50
			pos.y = randf_range(0, arena_rect.size.y)
			
	return pos
