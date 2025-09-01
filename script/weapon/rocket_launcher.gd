extends BaseWeapon

@export var rocketScene: PackedScene
@export var crosshairScene: PackedScene

var rocketSpeed: int = 700
var attackInterval: float = 0.9
		
var baseCritRate: float = 0.05
var baseCritDamage: float = 1.5
var rocketNum: int = 4
var extraCrosshairNum: int = 0
var extraRocketNum: int = 2
var hugeRocket: bool = false
var burningBuff: bool = false

func _ready():
	self.baseDamage = [2, 4, 8, 15, 30]
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.rocketNum += 2
			2: self.extraCrosshairNum = 2
			3: 
				self.extraRocketNum += 2
				self.rocketNum += 2
			4:
				self.hugeRocket = true
				self.burningBuff = true
		
	
func attack():
	var target = get_global_mouse_position()
	launch_rockets(target, rocketNum)
	
	for i in range(extraCrosshairNum):
		var ep = target + ((randi() % 500) + 300) * Vector2.from_angle(randf() * PI * 2)
		launch_rockets(ep, extraRocketNum)
	
	if hugeRocket:
		launch_rockets(target, 1, true)
	
func launch_rockets(target: Vector2, num: int, _huge: bool = false):
	var crosshair = crosshairScene.instantiate()
	GameInfo.mainscene.add_child(crosshair)
	crosshair.global_position = target
	
	for i in range(num):
		var rocket = rocketScene.instantiate()
		GameInfo.mainscene.bulletNode.add_child(rocket)
		
		var direction: Vector2 = Vector2.from_angle(randf() * PI * 2)
		var damage = DamageInfo.new(calculate_damage(_huge), 0, 
			randf() < self.baseCritRate + self.player.critRate,
			self.baseCritDamage, player)
		rocket.init(global_position, direction, target, rocketSpeed, damage, _huge, burningBuff)
	
func calculate_damage(huge: bool = false):
	if huge:
		return 300
	else:
		return self.baseDamage[self.level]
