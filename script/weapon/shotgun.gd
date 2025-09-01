extends BaseWeapon

@export var bulletScene: PackedScene

var bulletSpeed: int = 700
var shootAccuracy: float = 0.8
var attackInterval: float = 0.9
		
var baseCritRate: float = 0.05
var baseCritDamage: float = 1.5
	
var bulletNum: int = 5
var bulletWave: int = 1

func _ready():
	self.baseDamage = [3, 6, 10, 18, 30]
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.bulletNum += 2
			2: self.baseCritDamage += 0.5
			3: self.bulletNum += 3
			4:
				self.bulletWave = 3
				self.attackInterval = 0.6
		
	
func attack():
	var target = get_global_mouse_position()
	self.audioPlayer.play()
	for j in range(bulletWave):
		for i in range(bulletNum):
			var bullet = bulletScene.instantiate()
			GameInfo.mainscene.bulletNode.add_child(bullet)
			# calculate bias
			var direction: Vector2 = target - self.global_position + Vector2.from_angle(i - bulletNum / 2)
			var bias: Vector2 = direction.orthogonal() * (randf() * 2 - 1) * (1 - shootAccuracy)
			
			var damage = DamageInfo.new(calculate_damage(), 0, 
				randf() < self.baseCritRate + self.player.critRate,
				self.baseCritDamage, player)
			bullet.init(global_position, direction + bias, bulletSpeed, damage)
		await get_tree().create_timer(0.05).timeout
	
func calculate_damage():
	return self.baseDamage[self.level] + 0.6 * self.level + 0.2 * self.player.dexterrity
