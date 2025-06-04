extends BaseWeapon

@export var slashScene: PackedScene

var attackInterval: float = 1
var slashScale: float = 1.0
var baseDamage: int = 2
		
var baseCritRate: float = 0.05
var baseCritDamage: float = 2.0
var anis: Array[String] = ["flowerSlash", "backFlowerSlash2", "flowerSlash2"]
var lifeSteal: int = 0

func _ready():
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.slashScale += 0.4
			2: 
				self.anis.append("backFlowerSlash")
			3: self.slashScale += 0.6
			4:
				self.anis = ["flowerSlash", "backFlowerSlash2",
							"flowerSlash3", "backFlowerSlash",
							"flowerSlash2", "backFlowerSlash3"]
				self.lifeSteal = 1.0
				self.slashScale += 1
	
func attack():
	for ani in anis:
		self.audioPlayer.play()
		var target = get_global_mouse_position()
		var slash = slashScene.instantiate()
		self.player.add_child(slash)
		var direction: Vector2 = target - self.global_position
		var damage = DamageInfo.new(calculate_damage(ani), 0, 
			randf() < self.baseCritRate + self.player.critRate,
			self.baseCritDamage, player)
		slash.init(ani, direction, damage, slashScale * 2)
		slash.lifeSteal = lifeSteal
		await get_tree().create_timer(0.1).timeout
	
func calculate_damage(name: String):
	return self.baseDamage + (1 * self.level + 0.4 * self.player.strength) * \
	(0.1 * self.player.dexterrity + 1)
