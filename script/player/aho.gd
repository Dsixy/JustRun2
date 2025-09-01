extends BasePlayer

func _ready():
	self.weaponArm = preload("res://scene/weapon_arm/awu_kong.tscn").instantiate()

	self.animationPlayer.play("idle")
	
func init_stats():
	self.stamina = 3
	self.strength = 3
	self.insight = 2
	self.agility = 4
	self.charisma = 4
	self.perception = 2
	self.resilience = 0
	self.dexterrity = 2
	update()
	self.HP = self.maxHP
	
func update():
	self.maxHP = 100 + 7 * self.stamina + 5 * self.level
	self.armor = 25 + 1 * self.resilience + 2 * self.level
	self.speed = 250 + 3 * self.agility
	self.goldBonus = 0.08 * self.perception
	self.expBonus = 0.08 * self.perception
	self.critRate = 0.05 + 0.01 * self.agility + 0.01 * self.level
	self.pickupRange = 100 + 18 * self.perception + 7 * self.dexterrity
	
	self.pickupAreaShape.shape.radius = self.pickupRange
	self.discountRate = 1 - 0.02 * self.charisma
