extends CharacterBody2D

class_name Enemy

@export var speed: float = 100.0
@export var damage: int = 1
@export var hp: int = 1

var player: Player

func _ready() -> void:
	# Find player in the scene tree
	player = get_tree().get_first_node_in_group("player")
	if not player:
		# Fallback: try to find by name if group not set
		var root = get_tree().root.get_node("Main")
		if root:
			player = root.get_node_or_null("Player")

func _physics_process(delta: float) -> void:
	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
		
		# Rotate towards player
		rotation = direction.angle() + PI / 2

func take_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		die()

func die() -> void:
	# TODO: Spawn Gem
	GameManager.add_xp(1) # Temporary direct XP add
	queue_free()

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is Player:
		GameManager.take_damage(damage)
		queue_free() # Kamikaze
