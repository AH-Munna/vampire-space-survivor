extends CharacterBody2D

class_name Player

@export var acceleration: float = 800.0
@export var max_speed: float = 400.0
@export var friction: float = 600.0
@export var rotation_speed: float = 5.0

@onready var camera: Camera2D = $Camera2D
@onready var sprite: Sprite2D = $Sprite2D

# Arena bounds
const ARENA_WIDTH: int = 1600
const ARENA_HEIGHT: int = 900

func _ready() -> void:
	# Setup Camera Limits
	if camera:
		camera.limit_left = 0
		camera.limit_top = 0
		camera.limit_right = ARENA_WIDTH
		camera.limit_bottom = ARENA_HEIGHT
	
	# Setup initial position (center of arena)
	global_position = Vector2(ARENA_WIDTH / 2.0, ARENA_HEIGHT / 2.0)

@export var fire_rate: float = 0.5
@onready var projectile_scene: PackedScene = preload("res://src/weapons/Projectile.tscn")
var fire_timer: float = 0.0

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
		
	var projectile = projectile_scene.instantiate()
	# Spawn at ship position
	projectile.global_position = global_position
	# Direction is ship's forward vector (up relative to ship)
	# Since ship points UP at rotation 0, forward is Vector2.UP.rotated(rotation)
	# BUT, in Godot 0 rotation is usually RIGHT.
	# Let's check rotation logic: input_vector.angle() + PI/2.
	# If input is RIGHT (0), angle is PI/2 (DOWN?). Wait.
	# Vector2.RIGHT.angle() is 0. + PI/2 = PI/2 (DOWN).
	# So ship points DOWN at 0 input?
	# Standard Godot: 0 is RIGHT.
	# If sprite points UP, we need -PI/2 offset to align with RIGHT.
	# Let's assume sprite points UP.
	# To shoot "forward", we use the ship's rotation.
	# If rotation is correct, Vector2.UP.rotated(rotation) should be forward.
	# However, we added PI/2 to rotation.
	# Let's just use the rotation directly.
	projectile.direction = Vector2.UP.rotated(rotation)
	projectile.rotation = rotation
	
	# Add to main scene (root)
	get_tree().root.add_child(projectile)

