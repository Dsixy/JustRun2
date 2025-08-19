extends BaseEnemy

func _ready():
	self.animationPlayer.play("move")
	self.damage.baseAmount = 5.0

func init(level: int, wave: int):
	self.level = int(wave / 3) + 1
	reset_properties(wave)
	
func reset_properties(wave: int = 0):
	self.HP = 5 + (-2 + 3 * self.level) * wave
	self.damage.baseAmount = 15 * self.level
