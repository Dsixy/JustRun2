extends BaseWeapon

@export var shieldScene: PackedScene

const superBuff = preload("res://scene/buff/super_pro_buff.tscn")
var attackInterval: float = 1.0
var attackTime: int = 0
var requiredAttackTime: int = 10
		
var baseCritRate: float = 0.0
var baseCritDamage: float = 1.0
var maxStack: int = 1
var superPro: bool = false
	
func _ready():
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.requiredAttackTime -= 2
			2: self.maxStack = 2
			3: self.requiredAttackTime -= 3
			4: self.superPro = true
	
func attack():
	attackTime += 1
	var b = superBuff.instantiate()
	b.set_up(self)
	player.buffManager.add_buff(b)
	if attackTime >= requiredAttackTime:
		var shield = shieldScene.instantiate()
		shield.init(player, maxStack)
		player.add_child(shield)
		attackTime -= requiredAttackTime
	
func calculate_damage(name: String):
	return 0
