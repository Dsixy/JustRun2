extends BaseWeapon

@export var circleSlashScene: PackedScene

var attackInterval: float = 0.6
var currentPose: int = 0
var slashScale: float = 1.0

var pierceDamage:= []
var baseCritRate: float = 0.05
var baseCritDamage: float = 2.0
var pierceCritRate: float = 0.05
var pierceCritDamage: float = 2.0
var anis: Array[String] = ["circleSlash", "backCircleSlash"]
	
func _ready():
	self.baseDamage = [3, 6, 15, 27, 40]
	self.pierceDamage = [5, 12, 25, 55, 150]
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.slashScale += 0.2
			2: 
				self.anis.append("pierce")
			3: self.slashScale += 0.45
			4:
				self.pierceCritRate = 1.0
				self.pierceCritDamage += 2
	
func attack():
	for ani in anis:
		self.audioPlayer.play()
		var target = get_global_mouse_position()
		var slash = circleSlashScene.instantiate()
		self.player.add_child(slash)
		var direction: Vector2 = target - self.global_position
		var damage = calculate_damage(ani)
		slash.init(ani, direction, damage, slashScale * 4)
		await get_tree().create_timer(0.2).timeout
	
func calculate_damage(name: String):
	if name == "pierce":
		return DamageInfo.new(
			self.pierceDamage[self.level] + 6 * self.player.strength, 0, 
			randf() < self.pierceCritRate + self.player.critRate,
			self.pierceCritDamage, player, "Lightning")
	else:
		return DamageInfo.new(
			self.baseDamage[self.level] + 4 * self.player.strength, 0, 
			randf() < self.baseCritRate + self.player.critRate,
			self.baseCritDamage, player, "Lightning")
