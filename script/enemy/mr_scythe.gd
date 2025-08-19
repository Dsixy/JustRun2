extends BaseEnemy

@export var bulletScene: PackedScene
@export var slashScene: PackedScene
var isRush: bool = false
var bulletNum: int = 10
var bulletWave: int = 5
const shootAccuracy: float = 1
const bulletSpeed: int = 800
var bulletDamage: DamageInfo

func _ready():
	self.speed = 100
	self.damage.baseAmount = 10
	self.HP = 30
	reset_properties(0)
	
func _physics_process(delta):
	if not isRush:
		direction = (target - global_position).normalized()

	move_and_collide((direction * speed + extraVel) * delta)
	extraVel *= 0.95
	
func init(level: int, wave: int):
	self.level = level
	reset_properties(wave)
	
func reset_properties(wave: int = 0):
	self.HP = 50000
	self.damage.baseAmount = 20 * self.level + 5
	self.bulletDamage = DamageInfo.new()
	self.bulletDamage.baseAmount = 20 * self.level + 5
	
func rush():
	self.speed = 1500
	self.damage.bonus = 0.0
	self.isRush = true
	self.animationPlayer.play("Dash")
	await get_tree().create_timer(0.6).timeout
	self.animationPlayer.play("Move")
	self.speed = 100
	self.damage.bonus = 0.0
	self.isRush = false
	
func slash():
	animationPlayer.play("Slash")
	await animationPlayer.animation_finished
	animationPlayer.play("Move")
	
	var s = slashScene.instantiate()
	var di = (target - global_position).normalized()
	var slashDamage = DamageInfo.new(5)
	GameInfo.mainscene.add_child(s)
	s.init(global_position + 500 * di, di, slashDamage)
	
func shoot():
	animationPlayer.play("Idle")
	for j in range(bulletWave):
		for i in range(bulletNum):
			var bullet = bulletScene.instantiate()
			var direction: Vector2 = Vector2.from_angle((target - self.global_position).angle() + 0.2 * (i - bulletNum / 2))
			var bias: Vector2 = direction.orthogonal() * (randf() * 2 - 1) * (1 - shootAccuracy)
			GameInfo.mainscene.add_child(bullet)
			bullet.init(global_position, direction + bias, bulletSpeed, bulletDamage, 1)
			bullet.modulate = Color8(255, 100, 100)
		await get_tree().create_timer(0.1).timeout
	animationPlayer.play("Move")

func shout():
	pass
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	global_position = target + Vector2.from_angle(randf() * PI * 2) * 500

func _on_timer_timeout():
	var skills = ["rush", "shoot", "slash"]
	var skill = skills.pick_random()
	call(skill)
