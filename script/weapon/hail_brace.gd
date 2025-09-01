extends BaseWeapon

@export var windEffectScene: PackedScene
@export var whirlWindScene: PackedScene

var rangeBonus: float = 1.0
var attackInterval: float = 1.0
var whirlDamage: int = 15

var emitWhirlWind:= false
		
var baseCritRate: float = 0.05
var baseCritDamage: float = 1.5
	
func _ready():
	self.baseDamage = [2, 4, 8, 16, 30]
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.rangeBonus += 0.4
			2: self.rangeBonus += 0.6
			3: self.rangeBonus += 1
			4: self.emitWhirlWind = true
		
	
func attack():
	var direction = (get_global_mouse_position() - self.global_position).normalized()
	var windEffect = windEffectScene.instantiate()
	GameInfo.mainscene.add_child(windEffect)

	var damage = DamageInfo.new(calculate_damage("wind"), 0, 
		randf() < self.baseCritRate + self.player.critRate,
		self.baseCritDamage, player, "Ice")
	windEffect.init(global_position, direction, rangeBonus, damage)
	
	if emitWhirlWind:
		var whirlWind = whirlWindScene.instantiate()
		GameInfo.mainscene.add_child(whirlWind)
		damage = DamageInfo.new(calculate_damage("whirlWind"), 1, 
			randf() < self.baseCritRate + self.player.critRate,
			self.baseCritDamage, player, "Ice")
		whirlWind.init(global_position, direction, 2, damage)
	
func calculate_damage(name: String):
	if name == "wind":
		return self.baseDamage[self.level] + 2 * self.player.insight
	else:
		return self.whirlDamage + 2.5 * self.player.insight
