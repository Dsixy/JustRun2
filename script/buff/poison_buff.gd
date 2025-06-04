extends DotBuff
	
func set_up(source):
	super.set_up(source)
	self.tickInterval = 0.6
	self.duration = 4.5
	self.damage = DamageInfo.new(
		2 + 0.3 * source.level * (2 + 0.3 * source.insight),
		0, false, 1.0, source, "Poison"
	)
	
func apply(o):
	super.apply(o)
	_owner.modulate = Color8(0, 100, 0)
	if 0 in _owner.buffManager.activeBuff:
		self.tickInterval = 0.3
	elif 2 in _owner.buffManager.activeBuff:
		self.duration = 8
	elif 3 in _owner.buffManager.activeBuff:
		self.damage.baseAmount *= 1.5
	
func expire():
	_owner.modulate = Color8(255, 255, 255)
	super.expire()
