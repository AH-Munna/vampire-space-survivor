extends CharacterBody2D

class_name Player

# Movement Stats
@export var acceleration: float = 800.0
@export var max_speed: float = 400.0
@export var friction: float = 600.0
@export var rotation_speed: float = 5.0

# Combat Stats
@export var max_hp: int = 10
@export var fire_rate: float = 0.5
@export var projectile_count: int = 20 # testing FIXME: after sprite fix
@export var spread_angle: float = 15.0 # Degrees between bullets if multiple
@export var homing_bullets: bool = false

# State
var hp: int = max_hp
var xp: int = 0
var level: int = 1
var xp_next_level: int = 5
var fire_timer: float = 0.0

# Signals
signal xp_changed(current: int, max: int)
signal level_up(new_level: int)
signal hp_changed(current: int, max: int)
signal player_died

# Nodes
@onready var camera: Camera2D = $Camera2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var projectile_scene: PackedScene = preload("res://src/weapons/Projectile.tscn")
@onready var magnet_area: Area2D = $MagnetArea
@onready var magnet_shape: CollisionShape2D = $MagnetArea/CollisionShape2D

# Arena bounds
const ARENA_WIDTH: int = 2304
const ARENA_HEIGHT: int = 2304

func _ready() -> void:
	add_to_group("player")
	hp = max_hp
	
	# Connect Magnet Area
	if magnet_area:
		magnet_area.area_entered.connect(_on_magnet_area_entered)
	
	# Setup Camera Limits
	if camera:
		camera.limit_left = 0
		camera.limit_top = 0
		camera.limit_right = ARENA_WIDTH
		camera.limit_bottom = ARENA_HEIGHT
	
	# Setup initial position (center of arena)
	global_position = Vector2(ARENA_WIDTH / 2.0, ARENA_HEIGHT / 2.0)

func _physics_process(delta: float) -> void:
	# Auto-fire
	fire_timer -= delta
	if fire_timer <= 0.0:
		fire_timer = fire_rate
		shoot()

	var input_vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Rotate towards input direction if moving
	if input_vector != Vector2.ZERO:
		var target_angle: float = input_vector.angle() + PI / 2 # +90 deg because ships usually point up
		rotation = rotate_toward(rotation, target_angle, rotation_speed * delta)
		
		# Apply acceleration
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		# Apply friction
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()
	
	# Clamp position to arena
	global_position.x = clampf(global_position.x, 0, ARENA_WIDTH)
	global_position.y = clampf(global_position.y, 0, ARENA_HEIGHT)

func shoot() -> void:
	if not projectile_scene:
		return
		
	# Calculate starting angle offset to center the spread
	var total_arc = (projectile_count - 1) * spread_angle
	var start_angle = -total_arc / 2.0
	
	for i in range(projectile_count):
		var projectile = projectile_scene.instantiate()
		projectile.global_position = global_position
		
		var angle_offset = start_angle + (i * spread_angle)
		var final_rotation = rotation + deg_to_rad(angle_offset)
		
		projectile.direction = Vector2.UP.rotated(final_rotation)
		projectile.rotation = final_rotation
		
		if homing_bullets and projectile.has_method("set_homing"):
			projectile.set_homing(true)
		
		get_tree().root.add_child(projectile)

func take_damage(amount: int) -> void:
	hp -= amount
	print("Player HP: ", hp)
	emit_signal("hp_changed", hp, max_hp)
	if hp <= 0:
		emit_signal("player_died")

func game_over() -> void:
	# Deprecated, handled by signal
	pass

func gain_xp(amount: int) -> void:
	xp += amount
	print("XP: ", xp, "/", xp_next_level)
	emit_signal("xp_changed", xp, xp_next_level)
	
	if xp >= xp_next_level:
		level_up_player()

func level_up_player() -> void:
	xp -= xp_next_level
	level += 1
	xp_next_level = int(xp_next_level * 1.5)
	print("Level Up! Level: ", level)
	emit_signal("level_up", level)
	emit_signal("xp_changed", xp, xp_next_level)

func collect_powerup(type: int) -> void:
	# Type enum: 0=HEAL, 1=MAGNET, 2=BOMB, 3=SPEED
	match type:
		0: # HEAL
			hp = min(hp + 2, max_hp)
			emit_signal("hp_changed", hp, max_hp)
			print("Powerup: Heal")
		1: # MAGNET
			var gems = get_tree().get_nodes_in_group("gem")
			for gem in gems:
				if gem.has_method("start_magnet"):
					gem.start_magnet(self)
			print("Powerup: Magnet")
		2: # BOMB
			var enemies = get_tree().get_nodes_in_group("enemy")
			for enemy in enemies:
				var dist = global_position.distance_to(enemy.global_position)
				if dist < 400.0: # Bomb radius
					if enemy.has_method("die"):
						enemy.die()
			print("Powerup: Bomb")
		3: # SPEED
			max_speed += 200.0
			await get_tree().create_timer(5.0).timeout
			max_speed -= 200.0
			print("Powerup: Speed")

func _on_magnet_area_entered(area: Area2D) -> void:
	if (area.is_in_group("gem") or area.has_method("collect_powerup") or area.has_method("start_magnet")) and area.has_method("start_magnet"):
		area.start_magnet(self)

func increase_pickup_range(percent: float) -> void:
	if magnet_area:
		magnet_area.scale *= (1.0 + percent)
		print("Magnet Range Increased. Scale: ", magnet_area.scale)
