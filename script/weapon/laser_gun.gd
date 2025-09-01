extends BaseWeapon

@export var laserScene: PackedScene

var attackInterval: float:
	get:
		return 1.2 - 0.02 * self.player.dexterrity - self.extra
var laserScale: float = 0.4
var laserNum: int = 1
		
var baseCritRate: float = 0.05
var baseCritDamage: float = 1.5
var extra:= 0.0
	
func _ready():
	self.baseDamage = [7, 15, 30, 55, 150]
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.laserScale += 0.4
			2: 
				self.extra = 0.4
			3: self.laserScale += 1.0
			4:
				self.laserNum += 2
		
	
func attack():
	var target = get_global_mouse_position()
	for i in range(laserNum):
		var laser = laserScene.instantiate()
		player.add_child(laser)
		
		var damage = DamageInfo.new(calculate_damage(), 0, 
			randf() < self.baseCritRate + self.player.critRate,
			self.baseCritDamage, player)
		var angle = (target - self.global_position).angle() + (0.3 * i - 0.3 * 
		laserNum + 0.3 * int(laserNum / 2) + 0.3)
		laser.init(Vector2.from_angle(angle), damage, laserScale)
		laser.modulate = Color8(200, 240, 255)
	
func calculate_damage():
	return self.baseDamage[self.level]
