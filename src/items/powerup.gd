extends Area2D

class_name Powerup

enum Type { HEAL, MAGNET, BOMB, SPEED }

@export var type: Type = Type.HEAL

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	# Setup sprite frame based on type
	# Assuming 8x8 sprite sheet now
	$Sprite2D.hframes = 8
	$Sprite2D.vframes = 8
	
	match type:
		Type.HEAL:
			$Sprite2D.frame = 0 # Red cross / Heart
		Type.MAGNET:
			$Sprite2D.frame = 1 # Magnet icon
		Type.BOMB:
			$Sprite2D.frame = 2 # Bomb icon
		Type.SPEED:
			$Sprite2D.frame = 3 # Lightning/Speed icon

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("collect_powerup"):
			body.collect_powerup(type)
		queue_free()