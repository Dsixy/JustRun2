class_name PoisonBuff
extends DotBuff

const DamageTypes = preload("res://script/damage_types.gd")
	
func set_up(source):
	super.set_up(source)
	self.tickInterval = 0.6
	self.duration = 4.5
	self.damage = DamageInfo.new(
		2 + (0.4 * source.level + 5) * (2 + 0.3 * source.insight),
		0, false, 1.0, source, DamageTypes.POISON
	)
	
func apply(o):
	super.apply(o)
	_owner.modulate = Color8(0, 100, 0)
	
func expire():
	_owner.modulate = Color8(255, 255, 255)
	super.expire()
