extends Node

@onready var labelScene = preload("res://scene/UI/damage_label.tscn")
var rng = RandomNumberGenerator.new()

func random_weighted(weight: Array):
	var num = rng.randf()
	var now: float = 0.0
	
	for i in range(len(weight)):
		now += weight[i]
		if num < now: 
			return i 
	
	return len(weight)
	
func get_spawn_position_outside_camera(player_position: Vector2, camera_size: Vector2, margin: float = 200.0) -> Vector2:
	var side = randi() % 4  # 0=top, 1=bottom, 2=left, 3=right
	var spawn_pos = player_position

	match side:
		0:  
			spawn_pos.y -= camera_size.y / 2 + margin
			spawn_pos.x += randf_range(-camera_size.x / 2, camera_size.x / 2)
		1: 
			spawn_pos.y += camera_size.y / 2 + margin
			spawn_pos.x += randf_range(-camera_size.x / 2, camera_size.x / 2)
		2: 
			spawn_pos.x -= camera_size.x / 2 + margin
			spawn_pos.y += randf_range(-camera_size.y / 2, camera_size.y / 2)
		3: 
			spawn_pos.x += camera_size.x / 2 + margin
			spawn_pos.y += randf_range(-camera_size.y / 2, camera_size.y / 2)

	return spawn_pos

func show_damage_label(damage: DamageInfo, pos:Vector2):
	var label = labelScene.instantiate()
	GameInfo.mainscene.add_child(label)
	label.init(damage, pos)

func set_price(level: int, rarityFactor: float = 1.0):
	var wave = GameInfo.mainscene.wave
	match int(wave / 2):
		0: return 5 + (5 * rarityFactor + wave) * randf() + level * 1 
		1: return 0 + (10 * rarityFactor + 3 * wave) * randf() + level * 1.5
		2: return 10 + (15 * rarityFactor + 4 * wave) * randf() + level * 2
		3: return 10 + (18 * rarityFactor + 1.5 * wave) * randf() + level * 2.5
		_: return 20 + (20 * rarityFactor + 3 * wave) * randf() + level * 3
