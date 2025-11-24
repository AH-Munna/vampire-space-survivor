extends Area2D

class_name Projectile

@export var speed: float = 800.0
@export var damage: int = 10
@export var lifetime: float = 2.0

var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	# Connect cleanup signal
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)
	connect("body_entered", _on_body_entered)
	
	# Fallback timer in case it never leaves screen
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
