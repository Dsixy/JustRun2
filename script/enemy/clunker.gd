extends BaseEnemy
const COLOR_MUDOLATE = [Color8(255, 255, 255), Color8(150, 120, 90), Color8(90, 60, 35)]

func _ready():
	self.HP = 50
	self.scale = Vector2(2, 2)
	self.speed = 80

func init(level: int, wave: int):
	self.level = level
	$Sprite2D.modulate = COLOR_MUDOLATE[self.level - 1]
	reset_properties(wave)
	
func reset_properties(wave: int = 0):
	self.HP = 20 * (self.WAVE_SCALE[wave-1] + 10 * self.level)
	self.damage.baseAmount = 15 * level
