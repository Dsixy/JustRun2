extends BaseWeapon

const DamageTypes = preload("res://script/damage_types.gd")

@export var leafBulletScene: PackedScene

var attackInterval: float = 0.3

var baseCritRate: float = 0.05
var baseCritDamage: float = 2.0

var leafList = []
var followUPProb: float = 1.0
var comeBackDamageBonus: float = 0
var maxDistance: int = 800
var extraFollowUp: bool = false
var followUpLeafCount: int = 1

func _ready():
	self.baseDamage = [2, 4, 10, 25, 60]
	hide()

func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.comeBackDamageBonus = 0.4
			2: self.followUpLeafCount = 2
			3:
				self.maxDistance += 400
			4: self.extraFollowUp = true

func attack():
	for bullet: Node2D in leafList:
		if is_instance_valid(bullet):
			bullet.come_back()
	leafList.clear()

func shoot():
	var target = get_global_mouse_position()
	var offset := Vector2.from_angle(randf() * TAU) * randf() * 150.0
	var spawn_pos := player.global_position + offset
	var direction := (target - spawn_pos).normalized()
	var bullet = leafBulletScene.instantiate()
	GameInfo.mainscene.bulletNode.add_child(bullet)
	var damage = DamageInfo.new(calculate_damage(), 0,
		randf() < self.baseCritRate + self.player.critRate,
		self.baseCritDamage, player, DamageTypes.PHYSICAL)
	bullet.init(spawn_pos, direction, maxDistance, damage, player, comeBackDamageBonus)
	leafList.append(bullet)

func follow_up_attack():
	for _i in range(followUpLeafCount):
		shoot()
	if extraFollowUp:
		while randf() < 0.6:
			shoot()
			await get_tree().create_timer(0.05).timeout

func calculate_damage():
	return self.baseDamage[self.level]
