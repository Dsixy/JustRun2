extends TimeBuff

func apply(o):
	self._owner = o
	self._owner.isInvincible = true
	
func set_up(player: BasePlayer):
	super.set_up(player)
	self.duration = 15.0
	
func expire():
	self._owner.isInvincible = false
	emit_signal("on_expired")
