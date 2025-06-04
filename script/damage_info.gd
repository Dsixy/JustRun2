extends Resource

class_name DamageInfo

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
			
#const type2color = {
	#"": Color8(255, 255, 0),
	#"Poison": Color8(0, 255, 0),
	#"Fire": Color8(255, 0, 0),
	#"Ice": Color8(0, 0, 255),
	#"Lightning": Color8(0, 150, 255),
	#"Psychic": Color8(255, 150, 200),
#}

func _init(_damage: float = 0, _bonus: float = 0, _isCrit: bool = false,\
			_critDamage: float = 1.0, _source: Node = null, _type: String = ""):
	self.baseAmount = _damage
	self.bonus = _bonus
	self.isCrit = _isCrit
	self.critDamage = _critDamage
	self.source = _source
	self.damageType = _type

func copy() -> DamageInfo:
	var copy = DamageInfo.new()
	copy.baseAmount = baseAmount
	copy.bonus = bonus
	copy.critDamage = critDamage
	copy.damageType = damageType
	copy.isCrit = isCrit
	copy.source = source
	return copy
