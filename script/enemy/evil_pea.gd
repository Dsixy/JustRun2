extends BaseEnemy
const COLOR_MUDOLATE = [Color8(255, 255, 255), Color8(150, 150, 150), Color8(100, 100, 100)]

func _ready():
	self.animationPlayer.play("move")
	self.damage.baseAmount = 5.0

func init(level: int, wave: int):
	self.level = level
	$Sprite2D.modulate = COLOR_MUDOLATE[self.level - 1]
	reset_properties(wave)
	
func reset_properties(wave: int = 0):
	self.HP = 5 * self.WAVE_SCALE[wave - 1]
	self.damage.baseAmount = 15 * self.level
