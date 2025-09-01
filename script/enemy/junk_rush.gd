extends BaseEnemy

var isRush: bool = false
const COLOR_MUDOLATE = [Color8(255, 255, 255), Color8(150, 0, 0), Color8(100, 100, 100)]

func _ready():
	self.speed = 180
	self.damage.baseAmount = 10
	self.HP = 30
	
func _physics_process(delta):
	if not isRush:
		direction = (target - global_position).normalized()
		
	move_and_collide((direction * speed + extraVel) * delta)
	extraVel *= 0.95
	
func init(level: int, wave: int):
	self.level = level
	
	$Sprite2D.modulate = COLOR_MUDOLATE[self.level - 1]
	reset_properties(wave)
	
func reset_properties(wave: int = 0):
	self.HP = (3 + self.level * 3) * self.WAVE_SCALE[wave-1]
	self.damage.baseAmount = 20 * self.level + 10
	
func rush_to_target():
	self.speed *= 3
	self.damage.bonus = 1.0
	self.isRush = true
	self.animationPlayer.play("Rush")
	await get_tree().create_timer(1).timeout
	self.animationPlayer.play("Move")
	self.speed /= 3
	self.damage.bonus = 0.0
	self.isRush = false

func _on_timer_timeout():
	rush_to_target()
