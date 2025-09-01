extends BaseWeaponArm

# Called when the node enters the scene tree for the first time.
func _ready():
	var s = preload("res://scene/weapon/pistol.tscn")
	var c = s.instantiate()
	
	self.weaponList = [null, c, null, null]
