extends BaseWeapon

@export var optionScene: PackedScene
var baseDamage: int = 7
var baseCritRate: float = 0.05
var baseCritDamage: float = 2.0
var attackInterval: float:
	get:
		return 0.8 - 0.02 * self.player.dexterrity
	
var optionMove: bool = false
var optionNum: int = 1
var autoAttack: bool = false
var options = []

func _ready():
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.baseDamage += 5
			2: self.optionMove = true
			3: self.optionNum += 1
			4: self.autoAttack = true

func attack():
	if len(self.options) < self.optionNum:
		for i in range(self.optionNum - len(self.options)):
			var option = optionScene.instantiate()
			var pos: Vector2
			if optionMove:
				GameInfo.mainscene.itemNode.add_child(option)
			else:
				self.player.add_child(option)
			pos = Vector2.from_angle(randf() * 2 * PI) * 100
			
			self.options.append(option)
			var idx = self.options.find(option)
			var damage = DamageInfo.new(calculate_damage(), 0, 
				randf() < self.baseCritRate + self.player.critRate,
				self.baseCritDamage, player)
			option.init(global_position+pos, player, optionMove, autoAttack, damage, self.player.inventory[idx])
		
	if not autoAttack:
		for op in options:
			op.attack()
	
func calculate_damage():
	return self.baseDamage + 3 * self.level
	
func dearm():
	for op in options:
		op.de_equip()
		self.options.erase(op)
		op.queue_free()
