extends BaseWeapon

@export var leafBulletScene: PackedScene

var attackInterval: float = 1.2

var baseCritRate: float = 0.00
var baseCritDamage: float = 2.0

var leafList = []
var followUPProb: float = 1
var comeBackDamageBonus: float = 0
var maxDistance: int = 800
var extraFollowUp: bool = false

func _ready():
	self.baseDamage = [2, 4, 10, 25, 60]
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.followUPProb = 1.0
			2: self.comeBackDamageBonus = 0.4
			3: 
				self.maxDistance += 400
			4:  self.extraFollowUp = true

func attack():
	for bullet: Node2D in leafList:
		if is_instance_valid(bullet):
			bullet.come_back()
			
	leafList.clear()
	
func shoot():
	var target = get_global_mouse_position()
	var bullet = leafBulletScene.instantiate()
	GameInfo.mainscene.bulletNode.add_child(bullet)
	var damage = DamageInfo.new(calculate_damage(), 0, 
		randf() < self.baseCritRate + self.player.critRate,
		self.baseCritDamage, player)
	bullet.init(global_position, (target-global_position).normalized(), 
	maxDistance, damage, player, comeBackDamageBonus)
	
	leafList.append(bullet)
	
func follow_up_attack():
	if randf() < followUPProb:
		shoot()
	
	if extraFollowUp:
		while randf() < 0.6:
			shoot()
			await get_tree().create_timer(0.05).timeout
	
func calculate_damage():
	return self.baseDamage[self.level]
