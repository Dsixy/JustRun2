extends DotBuff

const maxStack:= 3
var curStack: int = 0

func set_up(source):
	super.set_up(source)
	self.duration = 4.0
	self.tickInterval = 1.0
	
	self.damage = DamageInfo.new(
		2 + source.insight * 0.4 + source.level * 0.2,
		0, false, 1.0, source, "Fire"
	)
	
func stack(buff: Buff):
	super.stack(buff)
	self.curStack = min(self.maxStack, self.curStack + 1)
	self.damage.baseAmount = 2 + curStack * (_source.insight * 0.4 + _source.level * 0.2)
	
func apply(o):
	super.apply(o)
	self.curStack = 1
	
func expire():
	super.expire()
