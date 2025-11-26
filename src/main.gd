extends Node2D

@onready var player: Player = $Player
@onready var hud: CanvasLayer = $HUD
@onready var upgrade_screen: CanvasLayer = $UpgradeScreen
@onready var start_menu: CanvasLayer = $StartMenu
@onready var game_over_screen: CanvasLayer = $GameOverScreen
@onready var spawn_manager: Node = $SpawnManager

func _ready() -> void:
	if player and hud:
		player.xp_changed.connect(hud.update_xp)
		player.level_up.connect(_on_level_up)
		player.level_up.connect(hud.update_level)
		player.hp_changed.connect(hud.update_hp)
		player.player_died.connect(_on_player_died)
		
		# Connect to SpawnManager
		if spawn_manager:
			player.level_up.connect(spawn_manager.on_level_up)
			
		# Initialize HP bar
		hud.update_hp(player.hp, player.max_hp)
	
	if upgrade_screen:
		upgrade_screen.upgrade_selected.connect(_on_upgrade_selected)
	
	if start_menu:
		start_menu.start_game.connect(_on_start_game)

func _on_start_game() -> void:
	# Game starts unpaused (handled by start menu hiding and unpausing tree)
	pass

func _on_player_died() -> void:
	game_over_screen.game_over()

func _on_level_up(level: int) -> void:
	# Special Upgrades Logic
	if level == 10:
		upgrade_screen.set_options(["homing"])
	elif level % 3 == 0:
		upgrade_screen.set_options(["max_hp"])
	else:
		upgrade_screen.set_options(["speed", "spread", "magnet"])
	
	upgrade_screen.open()

func _on_upgrade_selected(type: String) -> void:
	match type:
		"speed":
			player.fire_rate *= 0.9 # 10% faster (approx)
		"spread":
			player.projectile_count += 1
		"max_hp":
			player.max_hp += 5
			player.hp += 5
			hud.update_hp(player.hp, player.max_hp)
		"homing":
			player.homing_bullets = true
		"magnet":
			player.increase_pickup_range(0.35)
	print("Upgrade applied: ", type)
