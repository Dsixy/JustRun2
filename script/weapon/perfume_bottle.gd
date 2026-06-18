extends BaseWeapon

const DamageTypes = preload("res://script/damage_types.gd")

@export var sprayEffectScene: PackedScene

var range: float = 1.0
var attackInterval: float = 0.8

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
	"Catnip": 0,
}
var curContent: int = 0
var maxContent: int = 20

var oneCollect: int = 0

func _ready():
	self.baseDamage = [5, 7, 9, 11, 15]
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

func process_slot(cur: Node, drag: Node):
	if cur == drag:
		return [null, cur]
	if is_instance_of(cur, BaseWeapon) and is_instance_of(drag, BaseWeapon):
		if drag.id == cur.id and drag.id == id and drag.level == cur.level and drag.level < 4:
			_merge_collections(cur, drag)
			cur.upgrade()
			GameInfo.record_weapon_handbook_level(_weapon_key_from(cur), cur.level)
			return [cur, null]
	return [drag, cur]

func _merge_collections(target: BaseWeapon, donor: BaseWeapon) -> void:
	if not donor.get("collections"):
		return
	for key in collections.keys():
		target.collections[key] = maxi(target.collections[key], donor.collections[key])
	var total := 0
	for key in target.collections:
		total += target.collections[key]
	target.curContent = mini(total, target.maxContent)

func attack():
	var direction = (get_global_mouse_position() - self.global_position).normalized()
	var sprayEffect = sprayEffectScene.instantiate()
	player.add_child(sprayEffect)

	var damage = DamageInfo.new(calculate_damage(), 0,
		0,
		self.baseCritDamage, player, DamageTypes.POISON)
	sprayEffect.init(global_position, direction,\
				range + self.rangeBonus * self.collections["BlueMountainLeaf"], \
				400 + self.speedBonus * self.collections["WineRose"],
				damage, self.poisonBonus * self.collections["RaindropJasmine"])

func calculate_damage():
	return self.baseDamage[self.level] + self.damageBonus * self.collections["Hyacinth"]

func gain(name: String):
	if curContent <= maxContent:
		var add := oneCollect if oneCollect > 0 else 1
		self.collections[name] += add
		self.curContent += add
		self.curContent = mini(self.curContent, self.maxContent)
