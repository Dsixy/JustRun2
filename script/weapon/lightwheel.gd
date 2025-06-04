extends BaseWeapon

@export var wheelScene: PackedScene

var wheelSpeed: int = 700
var shootAccuracy: float = 0.6
var attackInterval: float = 1
var baseDamage: int = 4
var wheelDamage: int = 1
var wheelRangeBonus: float = 1
		
var baseCritRate: float = 0.05
var baseCritDamage: float = 2.0
	
var wheelNum: int = 2
var maxRun: int = 3
var light: bool = false
var wheels = []

func _ready():
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.wheelNum += 1
			2: 
				self.wheelRangeBonus += 0.3
				self.wheelDamage += 3
			3: 
				self.wheelNum += 1
				self.baseDamage += 6
			4: 
				self.wheelNum += 1
				self.maxRun += 2
				self.light = true
	
func attack():
	var target = get_global_mouse_position()
		
	for w in wheels:
		w.run(target)
		
	if len(wheels) < self.wheelNum:
		var wheel = wheelScene.instantiate()
		GameInfo.mainscene.bulletNode.add_child(wheel)
		# calculate bias
		
		var damage = DamageInfo.new(calculate_damage(""), 0, 
			randf() < self.baseCritRate + self.player.critRate,
			self.baseCritDamage, player)
		var wheelDamage = DamageInfo.new(calculate_damage("wheel"), 0, 
			randf() < self.baseCritRate + self.player.critRate,
			self.baseCritDamage, player)
		wheel.init(global_position, target, wheelSpeed, wheelRangeBonus,
				 damage, wheelDamage, maxRun, light)
		wheel.connect("death", _process_wheel_delete)
		wheels.append(wheel)
	
func _process_wheel_delete(w):
	wheels.erase(w)
	
func calculate_damage(name: String):
	if name == "wheel":
		return self.wheelDamage + 1 * self.level
	else:
		return self.baseDamage + 3 * self.level
