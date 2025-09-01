extends BaseWeapon

@export var bulletScene: PackedScene = preload("res://scene/item/bullet.tscn")

var bulletSpeed: int = 500
var range: float = 1.0
var damagePercent: float = 0.35
var keepBuff: bool = false
var shootAccuracy: float:
	get:
		return 0.9 + 0.05 * self.player.dexterrity
var attackInterval: float: 
	get:
		return 1 - self.player.dexterrity * 0.1
const baseCritRate: float = 0.05
const baseCritDamage: float = 2.0
	
func _ready():
	self.baseDamage = [12, 16, 20, 30, 50]
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.range += 0.2
			2: self.damagePercent = 0.55
			3: self.range += 0.4
			4:
				self.damagePercent = 1.0
				keepBuff = true

func attack():
	var bullet = bulletScene.instantiate()
	var target = get_global_mouse_position()
	
	GameInfo.mainscene.bulletNode.add_child(bullet)
	
	# calculate bias
	var direction: Vector2 = target - self.global_position
	var bias: Vector2 = direction.orthogonal() * (randf() * 2 - 1) * (1 - shootAccuracy)
	var damage = DamageInfo.new(calculate_damage(), 0, 
		randf() < self.baseCritRate + self.player.critRate,
		self.baseCritDamage, player)
	bullet.init(global_position, direction + bias, bulletSpeed, damage, \
				keepBuff, range, damagePercent)
	
func calculate_damage():
	return self.baseDamage[self.level]
