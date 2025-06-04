extends BaseWeapon

@export var sprayEffectScene: PackedScene

var range: float = 1.0
var attackInterval: float = 0.8
var baseDamage: int = 5
		
var baseCritRate: float = 0.0
var baseCritDamage: float = 1.0

var damageBonus: int = 2
var rangeBonus: float = 0.03
var intervalBonus: float = 0.01
var speedBonus: int = 0
var poisonBonus: float = 0.3
var collections = {
	"Hyacinth": 0,
	"BlueMountainLeaf": 0,
	"RaindropJasmine": 0,
	"WineRose": 0,
	"Catnip": 0
}
var curContent: int = 0
var maxContent: int = 20

var oneCollect: int = 0
	
func _ready():
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.range += 0.4
			2: self.oneCollect = 4
			3: self.range += 1
			4: 
				damageBonus = 5
				rangeBonus = 0.06
				speedBonus = 4
				poisonBonus = 0.8
				self.maxContent += 30
	
func attack():
	var direction = (get_global_mouse_position() - self.global_position).normalized()
	var sprayEffect = sprayEffectScene.instantiate()
	player.add_child(sprayEffect)

	var damage = DamageInfo.new(calculate_damage(), 0, 
		0,
		self.baseCritDamage, player)
	sprayEffect.init(global_position, direction,\
				range + self.rangeBonus * self.collections["BlueMountainLeaf"], \
				400 + self.speedBonus * self.collections["WineRose"],
				damage, self.poisonBonus * self.collections["RaindropJasmine"])
	
func calculate_damage():
	return self.baseDamage + 2 * self.level + self.damageBonus * self.collections["Hyacinth"]
	
func gain(name: String):
	if curContent <= maxContent:
		self.collections[name] += self.oneCollect
		self.curContent += self.oneCollect
