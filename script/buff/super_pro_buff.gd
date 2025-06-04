extends TimeBuff

func set_up(source):
	super.set_up(source)
	self.duration = 2.0
	
func modify_damage(damage: DamageInfo):
	damage.baseAmount = min(damage.baseAmount, _owner.maxHP * 0.1)
	return damage
