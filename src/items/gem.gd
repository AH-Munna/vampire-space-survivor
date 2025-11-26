extends Area2D

class_name Gem

@export var xp_value: int = 1
@export var magnet_speed: float = 800.0 # Increased from default
@export var acceleration: float = 2000.0 # Increased from default

var target: Node2D = null
var velocity: Vector2 = Vector2.ZERO
var is_collected: bool = false

func _ready() -> void:
	add_to_group("gem")
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if is_collected and target:
		var direction = (target.global_position - global_position).normalized()
		velocity = velocity.move_toward(direction * magnet_speed, acceleration * delta)
		global_position += velocity * delta
		
		if global_position.distance_to(target.global_position) < 10.0:
			collect()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		start_magnet(body)

func start_magnet(player_node: Node2D) -> void:
	target = player_node
	is_collected = true

func collect() -> void:
	if target.has_method("gain_xp"):
		target.gain_xp(xp_value)
	queue_free()
