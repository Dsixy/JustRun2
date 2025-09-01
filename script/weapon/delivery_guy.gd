extends BaseWeapon

@export var guyScene: PackedScene

var guySpeed: int = 400
var attackInterval: float = 0.9
		
var baseCritRate: float = 0.05
var baseCritDamage: float = 2.0
var guyNum: int = 2
var extraCoin: bool = false
var bringCoin: bool = false

func _ready():
	self.baseDamage = [2, 4, 10, 20, 40]
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.guyNum += 1
			2: self.extraCoin = true
			3: self.guyNum += 2
			4: self.bringCoin = true
		
	
func attack():
	for i in range(guyNum):
		if GameInfo.mainscene.enemies == []:
			return
			
		var target = GameInfo.mainscene.enemies.pick_random()
		var guy = guyScene.instantiate()
		GameInfo.mainscene.bulletNode.add_child(guy)
		
		var damage = DamageInfo.new(calculate_damage(), 0, 
			randf() < self.baseCritRate + self.player.critRate,
			self.baseCritDamage, player)
		guy.init(global_position, target, guySpeed, damage, player, extraCoin, bringCoin)
	
func calculate_damage():
	return self.baseDamage[self.level] + 0.5 * self.level * (2 + 0.5 * self.player.charisma)
