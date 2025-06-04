extends BaseWeaponArm

# Called when the node enters the scene tree for the first time.
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
	var s = preload("res://scene/weapon/falling_blossom.tscn")
	var c = s.instantiate()
	c.upgrade()
	c.upgrade()
	c.upgrade()
	c.upgrade()
	
	self.weaponList = [null, c, null, null]
