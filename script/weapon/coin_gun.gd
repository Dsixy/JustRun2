extends BaseWeapon

@export var bulletScene: PackedScene

var bulletSpeed: int = 700
var shootAccuracy: float = 0.6
var attackInterval: float = 0.4
		
var baseCritRate: float = 0.05
var baseCritDamage: float = 2.0
var damageBonus: float = 0
	
var bulletNum: int = 1
var short: int = 0
var coinRain: bool = false

func _ready():
	self.baseDamage = [10, 18, 35, 80, 150]
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.short = 1
			2: self.bulletNum += 2
			3: self.damageBonus = 0.001
			4: self.coinRain = true
		
func calculate_bullet_num():
	if self.coinRain and self.player.money > 2000:
		return [100, 20]
	if self.player.money < 50:
		return [0, 0]
	elif self.player.money < 100:
		return [1, 1]
	elif self.player.money < 200:
		return [2, 2]
	elif self.player.money < 500:
		return [3, 5]
	elif self.player.money < 1000:
		return [5, 8]
	else:
		return [8, 14]
	
func attack():
	var target = get_global_mouse_position()
	var out = calculate_bullet_num()
	var cost = out[0] - short
	var finalBulletNum = bulletNum + out[1]
	var wave = 1
	
	if coinRain and cost == 100:
		wave = 5
		
	for j in range(wave):
		for i in range(finalBulletNum):
			var bullet = bulletScene.instantiate()
			GameInfo.mainscene.bulletNode.add_child(bullet)
			# calculate bias
			var direction: Vector2 = target - self.global_position + Vector2.from_angle(i - bulletNum / 2)
			var bias: Vector2 = direction.orthogonal() * (randf() * 2 - 1) * (1 - shootAccuracy)
			
			var damage = DamageInfo.new(calculate_damage(), self.damageBonus * self.player.money, 
				randf() < self.baseCritRate + self.player.critRate,
				self.baseCritDamage, player)
			bullet.init(global_position, direction + bias, bulletSpeed * (0.4 * randf() + 0.8), damage)
		await get_tree().create_timer(0.1).timeout

	self.player.money -= cost
	
func calculate_damage():
	return self.baseDamage[self.level] + 4 * self.player.perception
