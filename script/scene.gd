extends Node2D

@export var expGemScene: PackedScene
@export var coinScene: PackedScene
@export var weaponArmScene: PackedScene

@onready var waveTimer = $WaveTimer
@onready var enemyGenerateTimer = $EnemyGenerateTimer
@onready var UIcontainer = $UI/Container
@onready var statsUI = $UI/StatsUI

@onready var bulletNode = $Bullet
@onready var enemyNode = $Enemy
@onready var itemNode = $Item
@onready var effectNode = $Effect

const expGemProb = [
	[0.3, 0, 0], [0.3, 0, 0],
	[0.3, 0.05, 0], [0.3, 0.05, 0], [0.3, 0.05, 0], [0.3, 0.05, 0], 
	[0.45, 0.07, 0], [0.45, 0.07, 0], [0.45, 0.07, 0], [0.45, 0.07, 0], 
	[0, 0.3, 0], 
	[0.5, 0.07, 0], [0.5, 0.07, 0], [0.5, 0.07, 0], [0.5, 0.07, 0], [0.5, 0.07, 0], 
	[0.5, 0.1, 0], [0.5, 0.1, 0], [0.5, 0.1, 0], [0.5, 0.1, 0], 
	[0.0, 0.5, 0.02],
	[0.3, 0.25, 0], [0.3, 0.25, 0], [0.3, 0.25, 0], [0.3, 0.25, 0], 
	[0, 0, 0.3],
	[0.1, 0.4, 0], [0.1, 0.4, 0], [0.1, 0.4, 0], [0.1, 0.4, 0], 
	[0, 0, 0.5]
]

var player: BasePlayer
var player_init_position: Vector2 = Vector2(960, 540)
	
# wave manage
var wave: int = 1
var wave_time: int = 0
var popocatScene = preload("res://scene/popocat.tscn")
var nextWave: bool = false

# enemy manage
var enemyList: Array[PackedScene] = [
	preload("res://scene/enemy/evil_pea.tscn"),
	preload("res://scene/enemy/junk_rush.tscn"),
	preload("res://scene/enemy/clunker.tscn"),
	preload("res://scene/enemy/wastewit.tscn")
]
var enemies: Array[BaseEnemy] = []
const enemyGenerate = [
	[],
	[[3, 3, 0], [0, 0, 0], [0, 0, 0], [15, 1, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]],
	[[3, 3, 0], [0, 0, 0], [0, 0, 0], [15, 1, 0], [0, 0, 0], [0, 0, 0]],
	[[3, 3, 0], [0, 0, 0], [0, 0, 0], [15, 1, 0], [0, 0, 0]],
	
	[[3, 3, 0], [0, 0, 0], [0, 0, 0], [15, 1, 0], [0, 0, 0], [0, 0, 0], [3, 3, 1]],
	[[8, 3, 0], [0, 0, 0], [15, 1, 0], [0, 0, 0], [0, 0, 0], [5, 3, 1]],
	[[15, 3, 0], [30, 1, 0], [10, 3, 1]],
	[[3, 3, 0], [0, 0, 0], [15, 1, 0], [3, 3, 1]],
	
	[[5, 3, 0], [10, 2, 1], [1, 1, 2], [5, 3, 0], [3, 1, 2]], 
	[[5, 3, 0], [10, 2, 1], [1, 1, 2], [5, 3, 0], [3, 1, 2]], 
	[[5, 3, 0], [10, 2, 1], [1, 1, 2], [5, 3, 0], [3, 1, 2]], 
	[[5, 3, 0], [10, 2, 1], [1, 1, 2], [5, 3, 0], [3, 1, 2]], 
	[[5, 3, 0], [10, 2, 1], [1, 1, 2], [5, 3, 0], [3, 1, 2]], 
	
	[[10, 3, 0], [5, 3, 1], [6, 2, 2], [10, 3, 0], [5, 3, 1], [6, 2, 2], [15, 1, 3]],
	[[10, 3, 0], [5, 3, 1], [6, 2, 2], [10, 3, 0], [5, 3, 1], [6, 2, 2], [15, 1, 3]],
	[[10, 3, 0], [5, 3, 1], [6, 2, 2], [10, 3, 0], [5, 3, 1], [6, 2, 2], [15, 1, 3]],
	[[10, 3, 0], [5, 3, 1], [6, 2, 2], [10, 3, 0], [5, 3, 1], [6, 2, 2], [15, 1, 3]],
	[[10, 3, 0], [5, 3, 1], [6, 2, 2], [10, 3, 0], [5, 3, 1], [6, 2, 2], [15, 1, 3]],
	
	[[10, 3, 1], [10, 2, 2], [15, 1, 3]],
	[[10, 3, 1], [10, 2, 2], [15, 1, 3]],
	[[10, 3, 1], [10, 2, 2], [15, 1, 3]],
	[[10, 3, 1], [10, 2, 2], [15, 1, 3]],
	[[10, 3, 1], [10, 2, 2], [15, 1, 3]],
	
	[[10, 3, 1], [10, 2, 2], [15, 1, 3]],
	[[10, 3, 1], [10, 2, 2], [15, 1, 3]],
	[[10, 3, 1], [10, 2, 2], [15, 1, 3]],
	[[10, 3, 1], [10, 2, 2], [15, 1, 3]],
	[[10, 3, 1], [10, 2, 2], [15, 1, 3]],
]
var enemyGenerateInterval: float = 0.0
var inWave: bool = false
var lootSceneList = [
	preload("res://scene/item/hyacinth.tscn"),
	preload("res://scene/item/blue_mountain_leaf.tscn"),
	preload("res://scene/item/wine_rose.tscn"),
	preload("res://scene/item/raindrop_jasmine.tscn"),
	preload("res://scene/item/catnip.tscn")
]

# UI manage
const abilityBoardScene = preload("res://scene/UI/player_ability_board.tscn")
const weaponArmBoardScene = preload("res://scene/UI/weapon_arm_board.tscn")
const bagBoardScene = preload("res://scene/UI/bag_board.tscn")
const shopBoardScene = preload("res://scene/UI/shop_board.tscn")

func _ready():
	load_player()
	load_event()
	GameInfo.mainscene = self	
	statsUI.player = self.player
	start_game()
	
func start_game():
	for i in range(30):
		await one_wave()
		if wave == 10 and GameInfo.config.get_value("Event", "first_to_wave_10") == false:
			Events.story_triggered.emit("first_to_wave_10")
		elif wave == 20 and GameInfo.config.get_value("Event", "first_to_wave_20") == false:
			Events.story_triggered.emit("first_to_wave_20")

		GameInfo.refresh()
		await popocat_shop()
		wave += 1
	final_results()
	
func final_results():
	const properties = [
		"stamina", "strength",
		"insight", "agility",
		"charisma", "perception",
		"resilience", "dexterrity",
	]
	for skill in properties:
		if player.get(skill) == 20 and GameInfo.config.get_value("Event", "first_%s_to_20" % skill) == false:
			Events.skill_triggered.emit(skill)

func _process(delta):
	set_enemy_direction()

# manage event
func load_event():
	Events.connect("story_triggered", _on_story_triggered)
	Events.connect("skill_triggered", _on_skill_triggered)
	Events.connect("level_triggered", _on_level_triggered)
	
func _on_story_triggered(storyName: String):
	pass
	match storyName:
		"first_to_wave_10": 
			carmor_come()
			GameInfo.config.set_value("Event", "first_to_wave_10", true)
		"first_to_wave_20": 
			alew_come()
			GameInfo.config.set_value("Event", "first_to_wave_20", true)
		_: pass
		
func _on_skill_triggered(skillName: String):
	match skillName:
		"stamina": GameInfo.config.set_value("WeaponUnlock", "mest", true)
		"strength": pass
		"insight": GameInfo.config.set_value("WeaponUnlock", "thought_bubble", true)
		"agility": GameInfo.config.set_value("WeaponUnlock", "poker", true)
		"charisma": GameInfo.config.set_value("WeaponUnlock", "song_of_soul", true)
		"perception": pass
		"resilience": pass
		"dexerity": GameInfo.config.set_value("WeaponUnlock", "poker", true)
		
func _on_level_triggered(level: int):
	pass
	
func carmor_come():
	var carmor = preload("res://scene/player/carmor.tscn").instantiate()
	var tween = get_tree().create_tween()
	
	focus()
	GameInfo.mainscene.add_child(carmor)
	carmor.global_position = player.global_position + Vector2(1000, 0)
	tween.tween_property(carmor, "global_position", player.global_position + Vector2(100, 0), 2)
	
	await tween.finished
	var dialogBubble = preload("res://scene/UI/dialog_bubble.tscn").instantiate()
	var dialogResource = preload("res://resource/dialog/d1.tres")
	carmor.add_child(dialogBubble)
	dialogBubble.init(carmor.global_position + Vector2(0, -200), dialogResource)
	await dialogBubble.dialog_completed
	carmor.queue_free()
	
	var w = preload("res://scene/weapon/laser_gun.tscn").instantiate()
	GameInfo.config.set_value("WeaponUnlock", "laser_gun", true)
	await show_item(w)
	var i = player.get_empty_inventory_idx()
	if i != -1:
		player.inventory[i] = w
		w.hide()
	else:
		w.queue_free()
	defocus()
	
func alew_come():
	var alew = preload("res://scene/player/alew.tscn").instantiate()
	var tween = get_tree().create_tween()
	
	focus()
	GameInfo.mainscene.add_child(alew)
	alew.global_position = player.global_position + Vector2(1000, 0)
	tween.tween_property(alew, "global_position", player.global_position + Vector2(100, 0), 2)
	
	await tween.finished
	var dialogBubble = preload("res://scene/UI/dialog_bubble.tscn").instantiate()
	var dialogResource = preload("res://resource/dialog/d1.tres")
	alew.add_child(dialogBubble)
	dialogBubble.init(alew.global_position + Vector2(0, -200), dialogResource)
	await dialogBubble.dialog_completed
	alew.queue_free()
	
	var w = preload("res://scene/weapon/falling_blossom.tscn").instantiate()
	GameInfo.config.set_value("WeaponUnlock", "falling_blossom", true)
	await show_item(w)
	var i = player.get_empty_inventory_idx()
	if i != -1:
		player.inventory[i] = w
		w.hide()
	else:
		w.queue_free()
	player.abilityPoint += 10
	
	defocus()
	
func focus():
	self.player.set_process(false)
	self.player.set_physics_process(false)

	var tween = get_tree().create_tween()
	tween.tween_property(GameInfo.mainscene.player.camera, "zoom", Vector2(2, 2), 1)
	
func defocus():
	self.player.set_process(true)
	self.player.set_physics_process(true)
	self.player.camera.zoom = Vector2(0.8, 0.8)
	
func show_item(item: Node):
	var effect = preload("res://scene/effect/gain_effect.tscn").instantiate()
	UIcontainer.add_child(effect)
	effect.position = Vector2(960, 540)
	effect.add_child(item)
	item.show()
	await effect.click
	
	effect.remove_child(item)
	effect.queue_free()
	
# manage player
func load_player():
	player = load(GameInfo.player).instantiate()
	add_child(player)
	
	player.init(player_init_position)
	player.connect("get_upgrade", player_updgrade)
	player.connect("go_die", player_dead)
	player.camera.enabled = true
	self.player = player
	
	var playerIcon = player.sprite.duplicate()
	statsUI.atlas.add_child(playerIcon)
	playerIcon.position = Vector2(100, 100)
	
func player_updgrade():
	pass

func player_dead():
	final_results()
# UI
func _open_ability_board():
	var abilityBoard = abilityBoardScene.instantiate()
	UIcontainer.add_child(abilityBoard)
	abilityBoard.init(player)
	abilityBoard.connect("board_close", _on_ui_close_board)
	get_tree().paused = true
	# Engine.time_scale = 0
	
func _on_ui_close_board():
	_on_board_closed()
	
func _on_ui_open_bag_board():
	_open_bag_board()
	_open_weapon_arm_board()
	
func _on_ui_open_ability_board():
	_open_ability_board()
	
func _open_weapon_arm_board():
	var weaponArmBoard = weaponArmBoardScene.instantiate()
	UIcontainer.add_child(weaponArmBoard)
	weaponArmBoard.init(player)
	get_tree().paused = true
	# Engine.time_scale = 0

func _open_bag_board():
	var bagBoard = bagBoardScene.instantiate()
	UIcontainer.add_child(bagBoard)
	bagBoard.init(player)
	get_tree().paused = true
	
func _open_shop_board():
	var shopBoard = shopBoardScene.instantiate()
	UIcontainer.add_child(shopBoard)
	shopBoard.init(player)
	shopBoard.connect("close", _on_board_closed)
	get_tree().paused = true

func _on_board_closed():
	get_tree().paused = false
	player.weaponArm.deactivate()
	var children = UIcontainer.get_children()
	for child in children:
		child.close_board()
	# Engine.time_scale = 1

# manage wave
func one_wave():
	wave_time = 27 + 2 * wave
	waveTimer.start(wave_time)
	inWave = true
	
	if wave == 30:
		var m = preload("res://scene/enemy/mr_scythe.tscn").instantiate()
		enemyNode.add_child(m)
		enemies.append(m)
		m.connect("death", process_enemy_death)
	
	var enemy_generate = enemyGenerate[wave]
	var idx = 0
	while inWave:
		generate_enemies(enemy_generate[idx])
		var generate_interval = 0.5 + len(enemies) * 0.1
		enemyGenerateTimer.start(generate_interval)
		await enemyGenerateTimer.timeout
		
		idx += 1
		idx = idx % len(enemy_generate)
	
	clear_enemy()

func _on_wave_timer_timeout():
	inWave = false

func popocat_shop():
	var popocat = popocatScene.instantiate()
	add_child(popocat)
	popocat.global_position = player.global_position + Vector2(-1000, 0)
	popocat.connect("click", _open_shop_board)
	await popocat.click
	
func shop_close():
	pass

# manage enemy
func generate_enemies(ene: Array):
	for i in range(ene[0]):
		var pos = Utils.get_spawn_position_outside_camera(player.global_position, Vector2(1920, 1080))
		for j in range(ene[1]):
			generate_enemy(ene[2], pos + 100 * Vector2(randf(), randf()))
	
func generate_enemy(idx: int, pos: Vector2):
	var i = idx % 4
	var l = int(idx / 4) + 1
	var e: BaseEnemy = enemyList[i].instantiate()
	enemyNode.add_child(e)
	e.global_position = pos
	e.init(l, wave)
	e.connect("death", process_enemy_death)
	
	enemies.append(e)
	return e
	
func process_enemy_death(enemy: BaseEnemy, pos: Vector2, willLoot: bool):
	if willLoot:
		var expGemLevel = Utils.random_weighted(expGemProb[wave])
		if expGemLevel < 3:
			var expGem = expGemScene.instantiate()
			itemNode.add_child(expGem)
			expGem.init(expGemLevel, pos)
		
		if randf() < (self.wave * 0.01 + 0.4):
			var coin = coinScene.instantiate()
			itemNode.add_child(coin)
			coin.init(pos)
			
		if randf() < 0.008:
			var loot = lootSceneList[Utils.random_weighted([0.2, 0.2, 0.2, 0.2, 0.2])].instantiate()
			itemNode.add_child(loot)
			loot.global_position = pos

	for weapon in self.player.weaponArm.weaponList:
		if weapon and weapon.id == 21 and weapon.collect:
			weapon.collectedSoul += 1
	enemies.erase(enemy)
	enemy.call_deferred("queue_free")
	
func set_enemy_direction():
	for e in enemies:
		e.update_target(player.global_position)

func _on_enemy_generate_timer_timeout():
	pass # Replace with function body.
	
func clear_enemy():
	for e in self.enemies:
		e.call_deferred("queue_free")
	
	self.enemies.clear()

