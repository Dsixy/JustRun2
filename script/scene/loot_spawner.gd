extends RefCounted
class_name LootSpawner

const LOOT_PROB: float = 0.012
const LOOT_PLANT_PROB = [0.1, 0.1, 0.5, 0.1, 0.2]

const LOOT_SCENES = [
	preload("res://scene/item/hyacinth.tscn"),
	preload("res://scene/item/blue_mountain_leaf.tscn"),
	preload("res://scene/item/wine_rose.tscn"),
	preload("res://scene/item/raindrop_jasmine.tscn"),
	preload("res://scene/item/catnip.tscn"),
]

const EXP_GEM_PROB = [
	[0, 0, 0],
	[0.3, 0, 0],
	[0.3, 0.05, 0],
	[0.45, 0.07, 0],
	[0, 0.3, 0],
	[0.5, 0.1, 0],
	[0.0, 0.5, 0.02],
	[0.3, 0.25, 0],
	[0, 0, 0.3],
	[0.1, 0.4, 0],
	[0, 0, 0.5],
]

var _scene: Node

func bind(scene: Node) -> void:
	_scene = scene

func spawn_enemy_loot(pos: Vector2, wave_table_index: int, wave: int) -> void:
	var exp_gem_level = Utils.random_weighted(EXP_GEM_PROB[wave_table_index])
	if exp_gem_level < 3:
		var exp_gem = _scene.expGemScene.instantiate()
		_scene.itemNode.add_child(exp_gem)
		exp_gem.init(exp_gem_level, pos)
		_scene.gemList.append(exp_gem)

	if randf() < (wave * 0.01 + 0.4):
		var coin = _scene.coinScene.instantiate()
		_scene.itemNode.add_child(coin)
		coin.init(pos)
		_scene.coinList.append(coin)

	if randf() < LOOT_PROB:
		var loot = LOOT_SCENES[Utils.random_weighted(LOOT_PLANT_PROB)].instantiate()
		_scene.itemNode.add_child(loot)
		loot.global_position = pos

func clear_wave_pickups() -> void:
	for coin in _scene.coinList:
		if is_instance_valid(coin) and randf() < 0.3:
			_scene.player.pick(coin.area)
		elif is_instance_valid(coin):
			coin.queue_free()
	_scene.coinList.clear()

	for gem in _scene.gemList:
		if is_instance_valid(gem) and randf() < 0.1:
			_scene.player.pick(gem.area)
		elif is_instance_valid(gem):
			gem.queue_free()
	_scene.gemList.clear()
