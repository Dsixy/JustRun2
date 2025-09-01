extends BaseWeapon

@export var spiritScene: PackedScene

var attackInterval: float = 1.2

var baseCritRate: float = 0.00
var baseCritDamage: float = 2.0

var spiritRadiusBonus: float = 0.0
var spiritHP: int = 20
var spiritMaxNum: int = 2
var spirits = []
var collect: bool = false
var collectedSoul: int = 0

func _ready():
	self.baseDamage = [2, 4, 8, 16, 40]
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.spiritMaxNum += 1
			2: self.spiritHP += 50
			3: 
				self.spiritMaxNum += 1
				self.spiritRadiusBonus += 0.4
			4: 
				self.collect = true

	
func attack():
	if len(spirits) < spiritMaxNum:
		var spirit = spiritScene.instantiate()
		GameInfo.mainscene.itemNode.add_child(spirit)
		spirit.init(global_position, spiritRadiusBonus, 
		spiritHP + 20 * self.player.insight + 15 * self.level, 
		calculate_damage(), self.level)
		spirits.append(spirit)
		spirit.connect("disappear", process_spirit_disappear)
	elif self.collect:
		var s = spirits.pick_random()
		s.gainPower(collectedSoul)
		collectedSoul = 0
		
func process_spirit_disappear(t: Node):
	spirits.erase(t)
	
func calculate_damage():
	return self.baseDamage[self.level] + 5 * self.player.perception
