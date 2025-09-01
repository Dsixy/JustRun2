extends BaseWeapon

@export var tearBulletScene: PackedScene
@export var tearBallScene: PackedScene
var baseCritRate: float = 0.05
var baseCritDamage: float = 2.0
var attackInterval: float = 2.0

var tearNum: int = 6
var bulletSpeed: int = 400
var explodeNum: int = 4
var always: bool = false
var maxStack: int = 4

func _ready():
	self.baseDamage = [2, 8, 12, 20, 34]
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: pass
			2: self.tearNum += 4
			3: 
				self.always = true
				self.explodeNum += 1
			4: 
				self.explodeNum += 2
				self.maxStack -= 1

func attack():
	for i in range(tearNum):
		var bullet = tearBulletScene.instantiate()
		GameInfo.mainscene.bulletNode.add_child(bullet)
		var direction = Vector2.from_angle(randf() * 2 * PI)
		var damage = DamageInfo.new(calculate_damage(), 0, 
			randf() < self.baseCritRate + self.player.critRate,
			self.baseCritDamage, player)
			
		bullet.init(global_position, direction, bulletSpeed, damage, 
		500 * (1.25 - 0.5 * randf()), explodeNum, tearBallScene, always, maxStack)
	
func calculate_damage():
	return self.baseDamage[self.level]
	
