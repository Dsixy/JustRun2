extends Resource

class_name DamageInfo

const DamageTypes = preload("res://script/damage_types.gd")

var baseAmount: float
var bonus: float
var source
var damageType: String
var isCrit: bool
var critDamage: float = 1.0
var finalDamage: int:
	get:
		if isCrit:
			return int(baseAmount * (1 + bonus) * critDamage)
		else:
			return int(baseAmount * (1 + bonus))

func _init(_damage: float = 0, _bonus: float = 0, _isCrit: bool = false,\
			_critDamage: float = 1.0, _source: Node = null, _type: String = DamageTypes.PHYSICAL):
	self.baseAmount = _damage
	self.bonus = _bonus
	self.isCrit = _isCrit
	self.critDamage = _critDamage
	self.source = _source
	self.damageType = DamageTypes.normalize(_type)

func copy() -> DamageInfo:
	var copy = DamageInfo.new()
	copy.baseAmount = baseAmount
	copy.bonus = bonus
	copy.critDamage = critDamage
	copy.damageType = damageType
	copy.isCrit = isCrit
	copy.source = source
	return copy

func get_type_display_name() -> String:
	return DamageTypes.display_name(damageType)
