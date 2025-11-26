extends Area2D

class_name Enemy

@export var speed: float = 100.0
@export var damage: int = 1
@export var hp: int = 1

var target: Node2D = null

func _ready() -> void:
	# Find player in the scene tree
	target = get_tree().get_first_node_in_group("player")
	
	# Connect collision signal
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	if target:
		# Homing logic
		var direction = (target.global_position - global_position).normalized()
		global_position += direction * speed * delta
		
		# Rotate towards player
		rotation = direction.angle() + PI / 2

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is Projectile:
		take_damage(area.damage)
		area.queue_free() # Destroy projectile

func take_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		die()

@export var gem_scene: PackedScene = preload("res://src/items/Gem.tscn")
@export var powerup_scene: PackedScene = preload("res://src/items/Powerup.tscn")

func die() -> void:
	# 10% chance to drop powerup
	if randf() < 0.10 and powerup_scene:
		var powerup = powerup_scene.instantiate()
		powerup.global_position = global_position
		# Random type: 0 to 2 (HEAL, MAGNET, BOMB) - Removed SPEED (3)
		powerup.type = randi() % 3
		get_parent().call_deferred("add_child", powerup)
	elif gem_scene:
		var gem = gem_scene.instantiate()
		gem.global_position = global_position
		get_parent().call_deferred("add_child", gem)
	queue_free()
