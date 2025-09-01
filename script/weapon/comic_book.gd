extends BaseWeapon

@export var superMonkeyScene: PackedScene

var monkeySpeed: int = 500
var attackInterval: float = 1.5

var monkeyNum: int = 1
var baseCritRate: float = 0.05
var baseCritDamage: float = 2.0
var counter:= 0
var maxTime:= 0
	
func _ready():
	self.baseDamage = [15, 25, 50, 120, 300]
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.monkeyNum += 2
			2: self.monkeyNum += 2
			3: self.monkeyNum += 2
			4:
				self.monkeyNum += 45
				self.maxTime = 5
		
	
func attack():
	if counter < maxTime:
		counter += 1
		return
	
	counter = 0
	for i in range(monkeyNum):
		var monkey = superMonkeyScene.instantiate()
		GameInfo.mainscene.bulletNode.add_child(monkey)
		
		var damage = DamageInfo.new(calculate_damage(), 0, 
			randf() < self.baseCritRate + self.player.critRate,
			self.baseCritDamage, player)
		var pos = global_position + Vector2(-1500, (2 * randf() - 1)* 600)
		monkey.init(pos, monkeySpeed, damage)
		await get_tree().create_timer(0.05).timeout
	
func calculate_damage():
	return self.baseDamage[self.level]
