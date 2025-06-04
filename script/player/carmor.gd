extends BasePlayer

func _ready():
	self.weaponArm = preload("res://scene/weapon_arm/mor.tscn").instantiate()
	self.animationPlayer.play("idle")
	
func init_stats():
	self.stamina = 2
	self.strength = 1
	self.insight = 2
	self.agility = 7
	self.charisma = 3
	self.perception = 2
	self.resilience = 1
	self.dexterrity = 2
	update()
	self.HP = self.maxHP
	
func update():
	self.maxHP = 50 + 5 * self.stamina + 5 * self.level
	self.armor = 35 + 1 * self.resilience + 1.5 * self.level
	self.speed = 275 + 5 * self.agility
	self.goldBonus = 0.08 * self.perception
	self.expBonus = 0.08 * self.perception
	self.critRate = 0.05 + 0.02 * self.agility + 0.01 * self.level
	self.pickupRange = 100 + 15 * self.perception + 5 * self.dexterrity
	
	self.pickupAreaShape.shape.radius = self.pickupRange
