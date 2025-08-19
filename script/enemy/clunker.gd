extends BaseEnemy

func _ready():
	self.HP = 50
	self.scale = Vector2(2, 2)
	self.speed = 80

func init(level: int, wave: int):
	self.level = int((wave - 10) / 7) + 1
	reset_properties(wave)
	
func reset_properties(wave: int = 0):
	self.HP = 50 + (-10 + 15 * self.level) * wave
	self.damage.baseAmount = 15 * level
