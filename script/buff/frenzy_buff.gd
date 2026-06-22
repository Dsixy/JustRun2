class_name FrenzyBuff
extends TimeBuff

## 敌人狂热：获得时大幅回血，持续期间回血并提升 outgoing 伤害（百科 enemies / buffs-and-damage）
const DAMAGE_SCALE := 1.5
const HEAL_ON_APPLY_RATIO := 0.5
const HEAL_PER_SECOND_RATIO := 0.15
const TICK_INTERVAL := 1.0

var tickTimer: float = 0.0
var _stored_contact: float = -1.0
var _stored_bullet: float = -1.0
var _has_bullet_damage: bool = false

func set_up(_source) -> void:
	super.set_up(_source)
	duration = 4.0

func apply(o) -> void:
	super.apply(o)
	if not is_instance_valid(_owner):
		return
	_apply_damage_buff()
	_heal_ratio(HEAL_ON_APPLY_RATIO)
	_owner.modulate = Color8(255, 110, 90)
	tickTimer = 0.0

func process(delta: float) -> void:
	if not is_instance_valid(_owner) or _owner.HP <= 0:
		expire()
		return
	super.process(delta)
	tickTimer += delta
	if tickTimer >= TICK_INTERVAL:
		tickTimer -= TICK_INTERVAL
		_heal_ratio(HEAL_PER_SECOND_RATIO)

func stack(buff: Buff) -> void:
	super.stack(buff)
	elapsed = 0.0
	tickTimer = 0.0
	_heal_ratio(HEAL_ON_APPLY_RATIO)

func expire() -> void:
	_restore_damage()
	if is_instance_valid(_owner):
		_owner.modulate = Color8(255, 255, 255)
	super.expire()

func _apply_damage_buff() -> void:
	if _stored_contact < 0.0:
		_stored_contact = _owner.damage.baseAmount
	_owner.damage.baseAmount = _stored_contact * DAMAGE_SCALE
	if _owner.get("bulletDamage") != null and _owner.bulletDamage != null:
		if _stored_bullet < 0.0:
			_stored_bullet = _owner.bulletDamage.baseAmount
		_owner.bulletDamage.baseAmount = _stored_bullet * DAMAGE_SCALE
		_has_bullet_damage = true

func _restore_damage() -> void:
	if not is_instance_valid(_owner):
		return
	if _stored_contact >= 0.0:
		_owner.damage.baseAmount = _stored_contact
	if _has_bullet_damage and _owner.get("bulletDamage") != null and _owner.bulletDamage != null:
		_owner.bulletDamage.baseAmount = _stored_bullet

func _heal_ratio(ratio: float) -> void:
	if not is_instance_valid(_owner):
		return
	var cap: int = int(_owner.maxHP)
	_owner.HP = mini(cap, _owner.HP + int(cap * ratio))
