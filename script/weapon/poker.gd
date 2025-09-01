extends BaseWeapon

@export var pokerBulletScene: PackedScene

var bulletSpeed: int = 500
var shootAccuracy: float:
	get:
		return 0.7 + self.player.dexterrity * 0.01
var attackInterval: float: 
	get:
		return 0.8 - self.player.dexterrity * 0.015
var pierce: int = 0
var pokerNum: int = 3
var spadeProb: float = 0.016
var pokerCounter: int = 0
var mustSpade: bool = false
var spadeExplodeRadius: int = 200

var explodeDamage:= []
var baseCritRate: float = 0.05
var baseCritDamage: float = 2.0
	
func _ready():
	self.baseDamage = [3, 5, 10, 20, 60]
	self.explodeDamage = [50, 80, 150, 270, 500]
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.pokerNum += 2
			2: self.pierce = 3
			3: self.pokerNum += 5
			4:
				self.mustSpade = true
				self.spadeExplodeRadius *= 1.5
		
	
func attack():
	for i in range(pokerNum):
		var poker = pokerBulletScene.instantiate()
		
		var idx = randi() % 3
		if randf() < spadeProb:
			idx = 3
			
		if mustSpade:
			pokerCounter += 1
			if pokerCounter == 30 or idx == 3:
				idx = 3
				pokerCounter = 0
			
		var target = get_global_mouse_position()
		
		GameInfo.mainscene.bulletNode.add_child(poker)
		
		# calculate bias
		var direction: Vector2 = target - self.global_position
		var bias: Vector2 = direction.orthogonal() * (randf() * 2 - 1) * (1 - shootAccuracy)
		
		var damage = DamageInfo.new(calculate_damage(idx), 0, 
			randf() < self.baseCritRate + self.player.critRate,
			self.baseCritDamage, player)
		poker.init(idx, global_position, direction + bias, bulletSpeed, damage, spadeExplodeRadius)
		poker.pierce = self.pierce
		await get_tree().create_timer(0.05).timeout
	
func calculate_damage(idx: int):
	if idx != 3:
		return self.baseDamage[self.level]
	else:
		return self.explodeDamage[self.level]
