extends BaseWeaponArm

func _ready():
	#var s = preload("res://scene/weapon/coin_gun.tscn")
	#var a = s.instantiate()
	#a.upgrade()
	#a.upgrade()
	#a.upgrade()
	#a.upgrade()
	#s = preload("res://scene/weapon/delivery_guy.tscn")
	#var b = s.instantiate()
	#b.upgrade()
	#b.upgrade()
	#b.upgrade()
	#b.upgrade()
	self.slotScale = 2.5
	var s = preload("res://scene/weapon/falling_blossom.tscn")
	var c = s.instantiate()
	c.upgrade()
	c.upgrade()
	c.upgrade()
	c.upgrade()
	
	self.weaponList = [null, c, null, null]
	
func update_content():
	self.contentAttackInterval = []
	self.content = [[weaponList[0], weaponList[1]], [weaponList[2], weaponList[3]]]
	for i in range(len(self.content)):
		var intervals = [0]
		for weapon in self.content[i]:
			if weapon:
				intervals.append(weapon.attackInterval)
		self.contentAttackInterval.append(intervals.max())
