extends BaseWeapon

@export var turretScene: PackedScene

var attackInterval: float = 1.2
var baseDamage: int = 4
		
var baseCritRate: float = 0.05
var baseCritDamage: float = 2.0
var turretRadiusBonus: float = 1.0
var turretAttackInterval: float = 0.8
var turretMaxNum: int = 3
var turrets = []
var pierce: bool = false

func _ready():
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.turretMaxNum += 1
			2: 
				self.baseDamage += 4
				self.turretAttackInterval -= 0.2
			3: self.turretMaxNum += 2
			4: 
				self.turretAttackInterval -= 0.3
				self.turretRadiusBonus += 1
				self.pierce = true
	
func attack():
	if len(turrets) < turretMaxNum:
		var pos = Vector2(randi() % 1600, randi() % 800) - Vector2(800, 400)
		var turret = turretScene.instantiate()
		GameInfo.mainscene.itemNode.add_child(turret)
		turret.init(global_position+pos, turretRadiusBonus, turretAttackInterval,
			baseCritRate+self.player.critRate, baseCritDamage, calculate_damage(), pierce)
		turrets.append(turret)
		turret.connect("disappear", process_turret_disappear)
		
func process_turret_disappear(t: Node):
	turrets.erase(t)
	
func calculate_damage():
	return self.baseDamage + 2 * self.level + 0.4 * self.player.perception
