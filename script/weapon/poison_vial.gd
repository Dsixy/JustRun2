extends BaseWeapon

@export var poisonBottleScene: PackedScene
var attackInterval: float = 1
var vialNum: int = 3
var range: float = 1.0
	
func _ready():
	self.baseDamage = [3, 5, 8, 15, 30]
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.vialNum += 2
			2: self.range += 0.4
			3: self.vialNum += 4
			4:
				self.range += 2
		
	
func attack():
	for i in range(vialNum):
		var poisonBottle = poisonBottleScene.instantiate()
		var bias = Vector2(randi_range(-600, 600), randi_range(-400, 400))
		GameInfo.mainscene.bulletNode.add_child(poisonBottle)
		
		var damage = DamageInfo.new(calculate_damage(), 0, 
			false,
			0, player)
		poisonBottle.init(global_position, global_position + bias, range, damage)
	
func calculate_damage():
	return self.baseDamage[self.level]
