extends BaseWeapon

@export var SongEffectScene: PackedScene

var baseRange: int = 500
var rangeBonus: float = 1.0
var attackInterval: float = 0.7
		
var baseCritRate: float = 0.05
var baseCritDamage: float = 2.0

var canKnockBack: bool = false
var canPick: bool = false
	
func _ready():
	self.baseDamage = [5, 8, 12, 20, 30]
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.rangeBonus += 0.4
			2: self.canKnockBack = true
			3: self.rangeBonus += 0.6
			4: 
				self.rangeBonus += 0.4
				self.canPick = true

func attack():
	var songEffect = SongEffectScene.instantiate()
	player.add_child(songEffect)
	# calculate bias

	var damage = DamageInfo.new(calculate_damage(), 0, 
		randf() < self.baseCritRate + self.player.critRate,
		self.baseCritDamage, player, "Psychic")
	songEffect.init(global_position, rangeBonus * baseRange, damage,\
					canKnockBack, canPick)
	
func calculate_damage():
	return self.baseDamage[self.level] + (1.5 * self.player.charisma\
		+ 1 * self.player.insight) * (1 + self.level)
