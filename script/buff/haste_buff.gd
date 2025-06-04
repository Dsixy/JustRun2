extends TimeBuff

func apply(o):
	self._owner = o
	self._owner.weaponArm.intervalScale = 0.5
	
func set_up(player: BasePlayer):
	super.set_up(player)
	self.duration = 15.0
	
func expire():
	self._owner.weaponArm.intervalScale = 1
	emit_signal("on_expired", self)
