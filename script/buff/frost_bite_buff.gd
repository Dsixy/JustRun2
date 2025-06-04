extends TimeBuff

var maxTrigger: int = 8
var trigger: int = 0
var bonus: int = 2.0
	
func set_up(source):
	super.set_up(source)
	self.duration = 5
	self.bonus = 2 + source.level * 0.5
	
func apply(o):
	super.apply(o)
	_owner.speed -= 50
	_owner.modulate = Color8(100, 100, 200)
	
func modify_damage(damage: DamageInfo):
	damage.baseAmount += bonus
	trigger += 1
	if trigger >= maxTrigger:
		expire()
	return damage
	
func stack(buff: Buff):
	super.stack(buff)
	trigger = 0
	
func expire():
	_owner.speed += 50
	_owner.modulate = Color8(255, 255, 255)
	super.expire()
