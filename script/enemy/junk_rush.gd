extends BaseEnemy

var isRush: bool = false

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
	self.level = int(wave / 12) + 1
	reset_properties(wave)
	
func reset_properties(wave: int = 0):
	self.HP = 10 + (-2 + 4 * self.level) * wave
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
