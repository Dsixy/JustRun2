extends BaseWeapon

var baseDamage: int = 7
var baseCritRate: float = 0.05
var baseCritDamage: float = 2.0
var attackInterval: float = 2.0

var extraCritDamage: float = 0.0
var extraCritRate: float = 0.0
var attackTimes: int = 1
var nextWeapon: BaseWeapon

func _ready():
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.attackInterval -= 0.4
			2: self.extraCritDamage = 1.5
			3: 
				self.extraCritRate = 1.0
				self.attackInterval -= 0.6
			4: 
				self.attackTimes = 2
				self.attackInterval -= 0.4

func attack():
	if nextWeapon:
		for i in range(self.attackTimes):
			nextWeapon.baseCritRate += extraCritRate
			nextWeapon.baseCritDamage += extraCritDamage
			nextWeapon.attack()
			nextWeapon.baseCritRate -= extraCritRate
			nextWeapon.baseCritDamage -= extraCritDamage
	
func calculate_damage():
	return 0
	
func arm(w: BaseWeaponArm):
	var list: Array = w.weaponList
	var idx = list.find(self)
	if idx == -1:
		self.nextWeapon = null
		return

	idx += 1

	while idx < list.size():
		if list[idx] is BaseWeapon and is_instance_valid(list[idx]):
			self.nextWeapon = list[idx]
			return
		idx += 1
		
	self.nextWeapon = null
	return 
