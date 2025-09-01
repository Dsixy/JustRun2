extends BasePlayer

func _ready():
	self.weaponArm = preload("res://scene/weapon_arm/lady.tscn").instantiate()
	self.animationPlayer.play("idle")
	
func init_stats():
	self.stamina = 1
	self.strength = 4
	self.insight = 2
	self.agility = 3
	self.charisma = 4
	self.perception = 2
	self.resilience = 2
	self.dexterrity = 2
	update()
	self.HP = self.maxHP
	
func update():
	self.maxHP = 100 + 7 * self.stamina + 5 * self.level
	self.armor = 35 + 1 * self.resilience + 1.5 * self.level
	self.speed = 250 + 3 * self.agility
	self.goldBonus = 0.10 * self.perception
	self.expBonus = 0.10 * self.perception
	self.critRate = 0.05 + 0.01 * self.agility + 0.01 * self.level
	self.pickupRange = 200 + 15 * self.perception + 5 * self.dexterrity
	
	self.pickupAreaShape.shape.radius = self.pickupRange
	self.discountRate = 1 - 0.02 * self.charisma
