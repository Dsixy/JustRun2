extends TimeBuff

const DamageTypes = preload("res://script/damage_types.gd")
const BurningBuffScript = preload("res://script/buff/burning_buff.gd")
const LightningBoltScene = preload("res://scene/effect/lightning_bolt.tscn")

var chain_range: float = 150.0
var max_chain_targets: int = 3
var spread_burning_stacks: int = 0

var tickInterval: float = 1.0
var tickTimer: float = 0.0

func set_up(source) -> void:
	super.set_up(source)
	duration = 4.0
	tickInterval = 1.0

func apply(o) -> void:
	super.apply(o)
	_owner.modulate = Color8(180, 210, 255)
	tickTimer = tickInterval
	_discharge_chain()

func process(delta: float) -> void:
	if not is_instance_valid(_owner) or _owner.HP <= 0:
		expire()
		return
	super.process(delta)
	tickTimer += delta
	if tickTimer >= tickInterval:
		tickTimer -= tickInterval
		_discharge_chain()

func stack(buff: Buff) -> void:
	super.stack(buff)
	if buff.get("_source"):
		_source = buff._source

func expire() -> void:
	if is_instance_valid(_owner):
		_owner.modulate = Color8(255, 255, 255)
	super.expire()

func _discharge_chain() -> void:
	if not is_instance_valid(_owner):
		return
	var origin: Vector2 = _owner.global_position
	for target in _pick_chain_targets(origin):
		if not is_instance_valid(target):
			continue
		target.be_hit(_build_chain_damage())
		_spawn_bolt(origin, target.global_position + Vector2(0, -40))
		if spread_burning_stacks > 0:
			BurningBuffScript.apply_stacks_to(target, _source, spread_burning_stacks)

func _pick_chain_targets(from_pos: Vector2) -> Array:
	var scene := GameInfo.get_run_scene()
	if scene == null or not scene.get("enemies"):
		return []
	var candidates: Array = []
	for enemy in scene.enemies:
		if not is_instance_valid(enemy) or enemy == _owner:
			continue
		if from_pos.distance_to(enemy.global_position) <= chain_range:
			candidates.append(enemy)
	candidates.shuffle()
	if candidates.size() > max_chain_targets:
		return candidates.slice(0, max_chain_targets)
	return candidates

func _build_chain_damage() -> DamageInfo:
	var level := _source_stat("level", 0)
	var insight := _source_stat("insight", 0)
	var amount := 4.0 + insight * 0.6 + level * 0.25
	var dmg := DamageInfo.new(amount, 0, false, 1.0, _source, DamageTypes.LIGHTNING)
	dmg.apply_lightning_buff = false
	dmg.skip_element_reactions = true
	return dmg

func _source_stat(prop: String, default_value: int) -> int:
	if _source == null:
		return default_value
	if _source.get(prop) != null:
		return int(_source.get(prop))
	if _source is BaseWeapon and _source.player and _source.player.get(prop) != null:
		return int(_source.player.get(prop))
	return default_value

func _spawn_bolt(from: Vector2, to: Vector2) -> void:
	var scene := GameInfo.get_run_scene()
	if scene == null or not scene.get("effectNode"):
		return
	var bolt = LightningBoltScene.instantiate()
	scene.effectNode.add_child(bolt)
	bolt.init(from, to)
