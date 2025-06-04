extends BaseWeapon

@export var bulletScene: PackedScene = preload("res://scene/item/bullet.tscn")
var bulletSpeed: int =1000
var shootAccuracy: float:
	get:
		return 0.8 + self.player.dexterrity * 0.01
var attackInterval: float: 
	get:
		return 0.8 - self.player.dexterrity * 0.03
var chainFire: float = 0.0
var chainFireNum: int = 4
var baseCritRate: float = 0.05
var baseCritDamage: float = 2.0
	
func _ready():
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.baseCritDamage += 0.5
			2: self.chainFire = 0.05
			3: self.baseCritRate += 0.3
			4: 
				self.chainFire = 0.3
				self.chainFireNum += 2

func attack():
	var bulletNum = 1
	if randf() < chainFire:
		bulletNum = chainFireNum
	
	var target = get_global_mouse_position()
	var direction: Vector2 = (target - self.global_position).normalized()
	
	for i in range(bulletNum):
		self.audioPlayer.play()
		var bullet = bulletScene.instantiate()
		GameInfo.mainscene.bulletNode.add_child(bullet)
		
		# calculate bias
		var bias: Vector2 = direction.orthogonal() * (randf() * 2 - 1) * (1 - shootAccuracy)
		var damage = DamageInfo.new(calculate_damage(), 0, 
			randf() < self.baseCritRate + self.player.critRate,
			self.baseCritDamage, player)
		bullet.init(global_position, direction + bias, bulletSpeed, damage)
		await get_tree().create_timer(0.06).timeout
	
func calculate_damage():
	return 10 + 5 * self.level
