class_name DotBuff extends TimeBuff

var tickInterval: float = 1.0
var tickTimer: float = 0.0
var damage: DamageInfo

func process(delta):
	super.process(delta)
	tickTimer += delta
	if tickTimer > tickInterval:
		tickTimer -= tickInterval
		on_tick()

func stack(buff: Buff):
	super.stack(buff)
	
func on_tick():
	if self._owner:
		self._owner.be_hit(damage.copy())
