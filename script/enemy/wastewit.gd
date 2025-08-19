extends BaseEnemy

@export var bulletScene: PackedScene
var target_distance: int = 600
var bulletNum: int = 3
const shootAccuracy: float = 0.6
const bulletSpeed: int = 200
var bulletDamage: DamageInfo = DamageInfo.new()

func _ready():
	self.speed = 150
	
func _physics_process(delta):
	direction = target - global_position
	var distance = direction.length()
	direction = direction.normalized()
	var move_dir = 1.2 if distance > target_distance else -0.4
	move_and_collide((direction * speed * move_dir + extraVel) * delta)
	extraVel *= 0.95
	
func init(level: int, wave: int):
	self.level = int((wave - 10) / 7) + 1
	reset_properties(wave)
	
func reset_properties(wave: int = 0):
	self.HP = 15 + (1 + 1 * self.level) * wave
	self.damage.baseAmount = 15 * self.level
	self.bulletDamage.baseAmount = 20 * self.level
	self.bulletNum = 3 + 2 * self.level
	
func shoot():
	for i in range(bulletNum):
		var bullet = bulletScene.instantiate()
		var direction: Vector2 = target - self.global_position + Vector2.from_angle(i - bulletNum / 2)
		var bias: Vector2 = direction.orthogonal() * (randf() * 2 - 1) * (1 - shootAccuracy)
		GameInfo.mainscene.add_child(bullet)
		bullet.init(global_position, direction + bias, bulletSpeed, bulletDamage, 1)
		bullet.modulate = Color8(255, 100, 100)

func _on_timer_timeout():
	shoot()
