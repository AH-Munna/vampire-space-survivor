extends CanvasLayer

signal back_pressed

@onready var grid: GridContainer = $Control/ScrollContainer/GridContainer

# Preload scenes to inspect
var scenes = {
	"Player": preload("res://src/actors/Player.tscn"),
	"Enemy": preload("res://src/actors/Enemy.tscn"),
	"Gem": preload("res://src/items/Gem.tscn"),
	"Powerup": preload("res://src/items/Powerup.tscn"),
	"Projectile": preload("res://src/weapons/Projectile.tscn")
}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	populate_grid()

func populate_grid() -> void:
	for scene_name in scenes:
		var scene = scenes[scene_name]
		var instance = scene.instantiate()
		
		# Create a container for this item
		var vbox = VBoxContainer.new()
		grid.add_child(vbox)
		
		# Label
		var label = Label.new()
		label.text = scene_name
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(label)
		
		# Control to hold the sprite (centered)
		var center_container = CenterContainer.new()
		center_container.custom_minimum_size = Vector2(128, 128)
		vbox.add_child(center_container)
		
		# Extract the sprite from the instance
		var sprite = find_sprite(instance)
		if sprite:
			# Duplicate the sprite to display it here
			var new_sprite = sprite.duplicate()
			new_sprite.position = Vector2(64, 64) # Center in container
			new_sprite.scale = Vector2(2, 2) # Scale up for visibility
			
			# If it's a powerup, maybe show all frames?
			# For now just show the default.
			
			# Create a Control node to act as parent for the sprite inside CenterContainer
			var sprite_holder = Control.new()
			sprite_holder.custom_minimum_size = Vector2(128, 128)
			center_container.add_child(sprite_holder)
			sprite_holder.add_child(new_sprite)
			
			# Add info label about frames
			var info = Label.new()
			info.text = "H: %d, V: %d" % [new_sprite.hframes, new_sprite.vframes]
			vbox.add_child(info)
			
		instance.queue_free()

func find_sprite(node: Node) -> Sprite2D:
	if node is Sprite2D:
		return node
	for child in node.get_children():
		var res = find_sprite(child)
		if res:
			return res
	return null

func _on_back_button_pressed() -> void:
	emit_signal("back_pressed")
	hide()
