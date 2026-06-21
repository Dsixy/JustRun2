extends TimeBuff

## 敌人基础伤害 ×0.7（降低 30%）
const DAMAGE_SCALE := 0.7

var _stored_base: float = -1.0

func set_up(_source) -> void:
	super.set_up(_source)
	duration = 5.0

func apply(o) -> void:
	super.apply(o)
	if _stored_base < 0:
		_stored_base = _owner.damage.baseAmount
		_owner.damage.baseAmount *= DAMAGE_SCALE
	if is_instance_valid(_owner):
		_owner.modulate = Color8(220, 180, 220)

func expire() -> void:
	if is_instance_valid(_owner) and _stored_base >= 0:
		_owner.damage.baseAmount = _stored_base
		_owner.modulate = Color8(255, 255, 255)
	super.expire()
