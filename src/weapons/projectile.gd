extends Area2D

class_name Projectile

@export var speed: float = 800.0
@export var damage: int = 10
@export var lifetime: float = 2.0

var direction: Vector2 = Vector2.RIGHT
var is_homing: bool = false
var homing_target: Node2D = null

func set_homing(enabled: bool) -> void:
	is_homing = enabled

func _ready() -> void:
	# Connect cleanup signal
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)
	
	# Fallback timer in case it never leaves screen
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	if is_homing:
		if not is_instance_valid(homing_target):
			# Find nearest enemy
			var enemies = get_tree().get_nodes_in_group("enemy")
			var nearest_dist = INF
			for enemy in enemies:
				var dist = global_position.distance_to(enemy.global_position)
				if dist < nearest_dist:
					nearest_dist = dist
					homing_target = enemy
		
		if is_instance_valid(homing_target):
			var target_dir = (homing_target.global_position - global_position).normalized()
			# Steer towards target
			direction = direction.move_toward(target_dir, 5.0 * delta).normalized()
			rotation = direction.angle() + PI/2

	global_position += direction * speed * delta
