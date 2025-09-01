extends BaseWeapon

@export var bulletScene: PackedScene

var bulletSpeed: int = 2000
var shootAccuracy: float = 1
var attackInterval: float: 
	get:
		return 2 - self.player.dexterrity * 0.1
var critPierce: int = 0
		
var baseCritRate: float = 0.35
var baseCritDamage: float = 2.0
	
func _ready():
	self.baseDamage = [25, 50, 80, 180, 350]
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.critPierce = 1
			2: self.baseCritDamage += 0.5
			3: self.critPierce = 7
			4: self.baseCritDamage += 1.5
		
	
func attack():
	self.audioPlayer.play()
	var bullet = bulletScene.instantiate()
	var target = get_global_mouse_position()
	
	GameInfo.mainscene.add_child(bullet)
	
	# calculate bias
	var direction: Vector2 = target - self.global_position
	var bias: Vector2 = direction.orthogonal() * (randf() * 2 - 1) * (1 - shootAccuracy)
	
	var damage = DamageInfo.new(calculate_damage(), 0, 
		randf() < self.baseCritRate + self.player.critRate,
		self.baseCritDamage, player)
	bullet.init(global_position, direction + bias, bulletSpeed, damage)
	if damage.isCrit:
		bullet.pierce = self.critPierce
	
func calculate_damage():
	return self.baseDamage[self.level]
