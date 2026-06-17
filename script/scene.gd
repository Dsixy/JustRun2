extends Node

const ViewportConstants = preload("res://script/viewport_constants.gd")
const PlayerSkillProperties = preload("res://script/player_skill_properties.gd")
const WeaponIds = preload("res://script/weapon_ids.gd")
const WaveDirector = preload("res://script/scene/wave_director.gd")
const LootSpawner = preload("res://script/scene/loot_spawner.gd")

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

const STORY_GUESTS := {
	"carmor": preload("res://scene/player/carmor.tscn"),
	"alew": preload("res://scene/player/alew.tscn"),
}
const STORY_WEAPONS := {
	"laser_gun": preload("res://scene/weapon/laser_gun.tscn"),
	"falling_blossom": preload("res://scene/weapon/falling_blossom.tscn"),
}

var player: BasePlayer
var player_init_position: Vector2 = ViewportConstants.CENTER

var wave: int = 1
var wave_time: int = 0
var popocatScene = preload("res://scene/popocat.tscn")
var gameoverFlag: bool = false

var enemyList: Array[PackedScene] = [
	preload("res://scene/enemy/evil_pea.tscn"),
	preload("res://scene/enemy/junk_rush.tscn"),
	preload("res://scene/enemy/clunker.tscn"),
	preload("res://scene/enemy/wastewit.tscn"),
]
var enemies: Array[BaseEnemy] = []
var enemyGenerateInterval: float = 0.0
var killEnemyCounter: int = 0
var lastWaveGenerationNum: int = 0
var killGeneRate: float = 0.0
var generateBonus: float = 1.0

var inWave: bool = false
var coinList = []
var gemList = []

var enemySetDirectionInterval: float = 1.0
var enemySetDirectionTimer: float = 0.0

var _wave_director := WaveDirector.new()
var _loot_spawner := LootSpawner.new()

func _ready():
	_wave_director.bind(self, _loot_spawner)
	_loot_spawner.bind(self)
	GameInfo.mainscene = self
	load_player()
	load_event()
	load_cfg()
	statsUI.player = self.player
	UIScene.player = self.player
	start_game()

func start_game():
	wave = 1
	killEnemyCounter = 0
	generateBonus = 1.0
	for i in range(WaveDirector.TOTAL_WAVES):
		GameInfo.refresh()
		await popocat_shop()
		await one_wave()
		if wave == WaveDirector.CARMOR_STORY_WAVE and not GameInfo.get_event("first_to_wave_3"):
			Events.story_triggered.emit("first_to_wave_3")
		elif wave == WaveDirector.ALEW_STORY_WAVE and not GameInfo.get_event("first_to_wave_6"):
			Events.story_triggered.emit("first_to_wave_6")

		RunStats.record_wave_cleared(wave)
		wave += 1
	win()

func _finish_run(victory: bool) -> void:
	var weapon_list: Array = player.weaponArm.weaponList.duplicate()
	RunStats.end_run(victory, player.level, weapon_list)
	await UnlockToast.wait_until_idle()
	var noteName: Array[String] = ["note"]
	var board = UIScene._open_ui_group(noteName, {
		"text": RunStats.get_summary_text(),
		"button_text": "返回主菜单",
	})[0]
	gameoverFlag = true
	await board.click
	UIScene._close_top_ui()
	get_tree().paused = false
	final_results()

func win():
	await _finish_run(true)

func final_results():
	for skill in PlayerSkillProperties.ALL:
		if player.get(skill) == 20 and not GameInfo.get_event("first_%s_to_20" % skill):
			Events.skill_triggered.emit(skill)

	GameInfo.player = ""
	get_tree().change_scene_to_file("res://scene/UI/main_menu.tscn")

func _process(delta):
	enemySetDirectionTimer += delta
	if enemySetDirectionTimer >= enemySetDirectionInterval:
		set_enemy_direction()
		enemySetDirectionTimer -= enemySetDirectionInterval
		enemySetDirectionInterval = randf_range(0.6, 1.4)

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
	match storyName:
		"first_to_wave_3":
			await _story_guest_arrives("carmor", "laser_gun")
			GameInfo.set_event("first_to_wave_3", true)
		"first_to_wave_6":
			await _story_guest_arrives("alew", "falling_blossom", 10)
			GameInfo.set_event("first_to_wave_6", true)

func _on_skill_triggered(skillName: String):
	var weapon_key := ""
	match skillName:
		"stamina": weapon_key = "mest"
		"insight": weapon_key = "thought_bubble"
		"charisma": weapon_key = "song_of_soul"
		"dexterrity": weapon_key = "poker"
	if weapon_key != "" and GameInfo.unlock_weapon(weapon_key):
		RunStats.notify_unlock(weapon_key)
	GameInfo.set_event("first_%s_to_20" % skillName, true)

func _on_level_triggered(level: int):
	if level == 10 and not GameInfo.get_event("first_to_level_10"):
		if GameInfo.unlock_weapon("hail_brace"):
			RunStats.notify_unlock("hail_brace")
		GameInfo.set_event("first_to_level_10", true)

func _story_guest_arrives(character_key: String, weapon_key: String, bonus_ability: int = 0) -> void:
	var guest_scene: PackedScene = STORY_GUESTS[character_key]
	var weapon_scene: PackedScene = STORY_WEAPONS[weapon_key]
	var guest = guest_scene.instantiate()
	var tween = get_tree().create_tween()

	focus()
	sceneLayer.add_child(guest)
	guest.global_position = player.global_position + Vector2(1000, 0)
	tween.tween_property(guest, "global_position", player.global_position + Vector2(100, 0), 2)
	await tween.finished

	var dialogBubble = preload("res://scene/UI/dialog_bubble.tscn").instantiate()
	var dialogResource = preload("res://resource/dialog/d1.tres")
	guest.add_child(dialogBubble)
	dialogBubble.init(guest.global_position + Vector2(0, -200), dialogResource)
	await dialogBubble.dialog_completed
	guest.queue_free()

	GameInfo.unlock_character(character_key)
	var weapon = weapon_scene.instantiate()
	if GameInfo.unlock_weapon(weapon_key):
		RunStats.notify_unlock(weapon_key)
	await show_item(weapon)
	var i = player.get_empty_inventory_idx()
	if i != -1:
		player.inventory[i] = weapon
		weapon.hide()
	else:
		weapon.queue_free()
	if bonus_ability > 0:
		player.abilityPoint += bonus_ability
	defocus()

func focus():
	player.set_process(false)
	player.set_physics_process(false)
	var tween = get_tree().create_tween()
	tween.tween_property(player.camera, "zoom", Vector2(2, 2), 1)

func defocus():
	player.set_process(true)
	player.set_physics_process(true)
	player.camera.zoom = Vector2(0.8, 0.8)

func show_item(item: Node):
	var effect = preload("res://scene/effect/gain_effect.tscn").instantiate()
	UIcontainer.add_child(effect)
	effect.position = ViewportConstants.CENTER
	effect.add_child(item)
	item.show()
	await effect.click
	effect.remove_child(item)
	effect.queue_free()

func load_player():
	RunStats.begin_run(GameInfo.player)
	player = load(GameInfo.player).instantiate()
	sceneLayer.add_child(player)
	player.init(player_init_position)
	player.connect("get_upgrade", player_updgrade)
	player.connect("go_die", player_dead)
	player.camera.enabled = true
	self.player = player

	var playerIcon = player.sprite.duplicate()
	player.money = 20
	player.refreshTime = 3
	statsUI.atlas.add_child(playerIcon)
	playerIcon.position = Vector2(100, 100)

func player_updgrade():
	var pos = player.global_position + Vector2(0, -50)
	Utils.show_floating_text("升级！", pos, Color8(255, 220, 80))
	Utils.show_floating_text("天赋点+2", pos + Vector2(0, -28), Color8(180, 255, 180))

func player_dead():
	await _finish_run(false)

func one_wave():
	await _wave_director.run_wave(wave)

func _on_wave_timer_timeout():
	_wave_director.end_wave()

func popocat_shop():
	if not GameInfo.get_event("seen_popocat_hint"):
		var noteName: Array[String] = ["note"]
		var hint = UIScene._open_ui_group(noteName, {
			"text": "点击左侧波波猫打开商店",
			"button_text": "知道了",
		})[0]
		await hint.click
		UIScene._close_top_ui()
		GameInfo.set_event("seen_popocat_hint", true)

	var popocat = popocatScene.instantiate()
	sceneLayer.add_child(popocat)
	popocat.global_position = player.global_position + Vector2(-1000, 0)
	popocat.connect("click", _open_shop_board)
	await popocat.click

func _open_shop_board():
	var shopName: Array[String] = ["shop"]
	var shop: Node = UIScene._open_ui_group(shopName)[0]
	shop.connect("close", shop_close)

func shop_close():
	UIScene._process_ui_signal(["shop"])

func process_enemy_death(enemy: BaseEnemy, pos: Vector2, willLoot: bool):
	RunStats.record_kill()
	if willLoot:
		_loot_spawner.spawn_enemy_loot(pos, _wave_director.wave_table_index(wave), wave)
		killEnemyCounter += 1

	for weapon in player.weaponArm.weaponList:
		if weapon and weapon.id == WeaponIds.SPIRIT_CONCH and weapon.collect:
			weapon.collectedSoul += 1
	enemies.erase(enemy)
	enemy.call_deferred("queue_free")

func set_enemy_direction():
	for e in enemies:
		e.update_target(player.global_position)

func clear_enemy():
	for e in enemies:
		e.call_deferred("queue_free")
	enemies.clear()

func _on_enemy_generate_timer_timeout():
	pass
