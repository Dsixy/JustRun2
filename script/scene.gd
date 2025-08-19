extends Node

@export var expGemScene: PackedScene
@export var coinScene: PackedScene
@export var weaponArmScene: PackedScene

@onready var waveTimer = $PhysicalLayer/WaveTimer
@onready var enemyGenerateTimer = $PhysicalLayer/EnemyGenerateTimer
@onready var UIScene = $UI
@onready var UIcontainer = $UI/Container
@onready var statsUI = $UI/StatsUI

@onready var bulletNode = $PhysicalLayer/Bullet
@onready var enemyNode = $PhysicalLayer/Enemy
@onready var itemNode = $PhysicalLayer/Item
@onready var effectNode = $PhysicalLayer/Effect
@onready var sceneLayer = $PhysicalLayer

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
var gameoverFlag: bool = false

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
var killEnemyCounter: int = 0
var lastWaveGenerationNum: int = 0
var killGeneRate: float = 0.0
var generateBonus: float = 1.0

var inWave: bool = false
var lootSceneList = [
	preload("res://scene/item/hyacinth.tscn"),
	preload("res://scene/item/blue_mountain_leaf.tscn"),
	preload("res://scene/item/wine_rose.tscn"),
	preload("res://scene/item/raindrop_jasmine.tscn"),
	preload("res://scene/item/catnip.tscn")
]
var coinList = []
var gemList = []

# some constant
var enemySetDirectionInterval: float = 1.0
var enemySetDirectionTimer: float = 0.0

func _ready():
	GameInfo.mainscene = self
	load_player()
	load_event()
	load_cfg()
	statsUI.player = self.player
	UIScene.player = self.player
	start_game()
	
func start_game():
	for i in range(10):
		await one_wave()
		if wave == 10 and GameInfo.config.get_value("Event", "first_to_wave_10") == false:
			Events.story_triggered.emit("first_to_wave_10")
		elif wave == 20 and GameInfo.config.get_value("Event", "first_to_wave_20") == false:
			Events.story_triggered.emit("first_to_wave_20")

		GameInfo.refresh()
		await popocat_shop()
		wave += 3
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
			
	GameInfo.player = ""
	get_tree().change_scene_to_file("res://scene/UI/main_menu.tscn")

func _process(delta):
	enemySetDirectionTimer += delta
	if enemySetDirectionTimer >= enemySetDirectionInterval:
		set_enemy_direction()
		enemySetDirectionTimer -= enemySetDirectionInterval
		enemySetDirectionInterval = randf_range(0.6, 1.4)

# manage event
func load_event():
	Events.connect("story_triggered", _on_story_triggered)
	Events.connect("skill_triggered", _on_skill_triggered)
	Events.connect("level_triggered", _on_level_triggered)
	
func load_cfg():
	if GameInfo.cheat:
		player.money = 10000
		player.abilityPoint = 500
		player.refreshTime = 1000
		
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
	sceneLayer.add_child(carmor)
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
	sceneLayer.add_child(alew)
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
	sceneLayer.add_child(player)
	
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
	var noteName: Array[String] = ["note"]
	var board = UIScene.open_UI_board(noteName, {"text": "You Loss", "button_text": "Restart"})
	gameoverFlag = true
	await board.click
	get_tree().paused = false
	
	final_results()
	
# manage wave
func one_wave():
	wave_time = 27 + 2 * wave
	waveTimer.start(wave_time)
	inWave = true
	
	if wave >= 30:
		var m = preload("res://scene/enemy/mr_scythe.tscn").instantiate()
		enemyNode.add_child(m)
		enemies.append(m)
		m.connect("death", process_enemy_death)
	
	var enemy_generate = enemyGenerate[wave]
	var idx = 0
	while inWave:
		generate_enemies(enemy_generate[idx])
		lastWaveGenerationNum = enemyNode.get_child_count()
		var generate_interval = clamp(0.5 + len(enemies) * 0.1, 0.5, 4)
		enemyGenerateTimer.start(generate_interval)
		await enemyGenerateTimer.timeout
		
		idx += 1
		idx = idx % len(enemy_generate)
	
		if lastWaveGenerationNum == 0:
			continue
			
		killGeneRate = killEnemyCounter / lastWaveGenerationNum
		if killGeneRate <= 0.3:
			generateBonus *= 0.5
		elif killGeneRate <= 0.9:
			generateBonus *= 0.8
		elif killGeneRate <= 1.2:
			generateBonus *= 1.25
		elif killGeneRate <= 1.5:
			generateBonus *= 1.6
		else:
			generateBonus *= 3.0
			
		generateBonus = clamp(generateBonus, 0.5, 5)
			
	clear_enemy()
	clear_coin_and_gem()

func _on_wave_timer_timeout():
	inWave = false

func clear_coin_and_gem():
	for coin in coinList:
		if is_instance_valid(coin) and randf() < 0.3:
			player.pick(coin.area)
		elif is_instance_valid(coin):
			coin.queue_free()
			
	coinList.clear()
	
	for gem in gemList:
		if is_instance_valid(gem) and randf() < 0.1:
			player.pick(gem.area)
		elif is_instance_valid(gem):
			gem.queue_free()
			
	gemList.clear()
	
func popocat_shop():
	var popocat = popocatScene.instantiate()
	sceneLayer.add_child(popocat)
	popocat.global_position = player.global_position + Vector2(-1000, 0)
	popocat.connect("click", _open_shop_board)
	await popocat.click
	
func _open_shop_board():
	var shopName: Array[String] = ["shop"]
	var shop: Node = UIScene.open_UI_board(shopName)
	shop.connect("close", shop_close)
	
func shop_close():
	var shopName: Array[String] = ["shop"]
	UIScene.UIFocusStack.erase(["shop"])
	UIScene.close_UI_board(shopName)

# manage enemy
func generate_enemies(ene: Array):
	var counter = 0
	for i in range(int(ene[0] * generateBonus)):
		var pos = Utils.get_spawn_position_outside_camera(player.global_position, Vector2(1920, 1080))
		for j in range(ene[1]):
			generate_enemy(ene[2], pos + 100 * Vector2(randf(), randf()))
			counter += 1
	
	return counter
	
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
			gemList.append(expGem)
		
		if randf() < (self.wave * 0.01 + 0.4):
			var coin = coinScene.instantiate()
			itemNode.add_child(coin)
			coin.init(pos)
			coinList.append(coin)
			
		if randf() < 0.008:
			var loot = lootSceneList[Utils.random_weighted([0.2, 0.2, 0.2, 0.2, 0.2])].instantiate()
			itemNode.add_child(loot)
			loot.global_position = pos
			
		killEnemyCounter += 1

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

