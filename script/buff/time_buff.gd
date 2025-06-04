class_name TimeBuff extends Buff

var duration: float = 0.0
var elapsed: float = 0.0
	
func stack(buff: Buff):
	self.elapsed = 0.0
	
func process(delta):
	self.elapsed += delta
	if elapsed >= duration:
		expire()
