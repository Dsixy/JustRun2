extends RefCounted
class_name WaveDirector

const ViewportConstants = preload("res://script/viewport_constants.gd")

const TOTAL_WAVES := 10
const CARMOR_STORY_WAVE := 3
const ALEW_STORY_WAVE := 6
const BOSS_WAVE := 10

const ENEMY_GENERATE = [
	[],
	[[3, 3, 0, 1], [0, 0, 0, 1], [0, 0, 0, 1], [15, 1, 0, 1], [0, 0, 0, 1], [0, 0, 0, 1]],
	[[3, 3, 0, 1], [0, 0, 0, 1], [0, 0, 0, 1], [15, 1, 0, 1], [0, 0, 0, 1], [0, 0, 0, 1], [3, 3, 1, 1]],
	[[8, 3, 0, 1], [0, 0, 0, 1], [15, 1, 0, 1], [0, 0, 0, 1], [0, 0, 0, 1], [5, 3, 1, 1]],
	[[5, 3, 0, 1], [10, 2, 1, 1], [1, 1, 2, 1], [5, 3, 0, 2], [3, 1, 2, 1]],
	[[10, 3, 0, 1], [5, 3, 1, 1], [6, 2, 2, 1], [10, 3, 0, 1], [5, 3, 1, 1], [6, 2, 2, 1], [15, 1, 3, 1]],
	[[10, 3, 1, 2], [10, 2, 2, 1], [15, 1, 3, 1]],
	[[10, 3, 1, 2], [10, 2, 2, 2], [15, 1, 3, 2], [20, 1, 0, 3]],
	[[15, 1, 0, 3], [15, 2, 1, 3], [25, 1, 3, 2]],
	[[10, 1, 2, 3], [10, 1, 1, 3], [10, 1, 3, 3]],
	[[5, 1, 0, 3], [5, 1, 2, 3], [5, 1, 1, 3], [5, 1, 3, 3]],
]

const WAVE_TIME = [
	30, 35, 40, 45, 45, 50, 50, 50, 55, 60
]

var _scene: Node
var _loot: LootSpawner

func bind(scene: Node, loot: LootSpawner) -> void:
	_scene = scene
	_loot = loot

func wave_table_index(wave: int) -> int:
	return clampi(wave, 1, ENEMY_GENERATE.size() - 1)

func run_wave(wave: int) -> void:
	_scene.killEnemyCounter = 0
	_scene.wave_time = WAVE_TIME[wave-1]
	_scene.waveTimer.start(_scene.wave_time)
	_scene.inWave = true

	if wave == BOSS_WAVE:
		var boss = preload("res://scene/enemy/mr_scythe.tscn").instantiate()
		_scene.enemyNode.add_child(boss)
		_scene.enemies.append(boss)
		boss.connect("death", _scene.process_enemy_death)

	var enemy_generate: Array = ENEMY_GENERATE[wave_table_index(wave)]
	var idx := 0
	while _scene.inWave:
		_generate_enemies(enemy_generate[idx])
		_scene.lastWaveGenerationNum = _scene.enemyNode.get_child_count()
		var generate_interval = clampf(0.5 + _scene.enemies.size() * 0.1, 0.5, 4.0)
		_scene.enemyGenerateTimer.start(generate_interval)
		await _scene.enemyGenerateTimer.timeout

		idx += 1
		idx = idx % enemy_generate.size()

		if _scene.lastWaveGenerationNum == 0:
			continue

		_scene.killGeneRate = _scene.killEnemyCounter / float(_scene.lastWaveGenerationNum)
		if _scene.killGeneRate <= 0.3:
			_scene.generateBonus *= 0.5
		elif _scene.killGeneRate <= 0.9:
			_scene.generateBonus *= 0.8
		elif _scene.killGeneRate <= 1.2:
			_scene.generateBonus *= 1.25
		elif _scene.killGeneRate <= 1.5:
			_scene.generateBonus *= 1.6
		else:
			_scene.generateBonus *= 3.0
		_scene.generateBonus = clampf(_scene.generateBonus, 0.5, 3.0)

	_scene.clear_enemy()
	_loot.clear_wave_pickups()

func end_wave() -> void:
	_scene.inWave = false

func _generate_enemies(ene: Array) -> int:
	var counter := 0
	for i in range(int(ene[0] * _scene.generateBonus)):
		var pos = Utils.get_spawn_position_outside_camera(
			_scene.player.global_position, ViewportConstants.SIZE
		)
		for _j in range(ene[1]):
			_spawn_enemy(ene[2], ene[3], pos + 100 * Vector2(randf(), randf()))
			counter += 1
	return counter

func _spawn_enemy(idx: int, level: int, pos: Vector2) -> BaseEnemy:
	var i = idx % _scene.enemyList.size()
	var l = maxi(level, 1)
	var enemy: BaseEnemy = _scene.enemyList[i].instantiate()
	_scene.enemyNode.add_child(enemy)
	enemy.global_position = pos
	enemy.init(l, _scene.wave)
	enemy.connect("death", _scene.process_enemy_death)
	_scene.enemies.append(enemy)
	return enemy
