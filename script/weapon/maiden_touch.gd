extends BaseWeapon

@export var grabScene: PackedScene

var attackInterval: float = 1.2
var grabScale: float = 1.0
var baseDamage: int = 3
		
var baseCritRate: float = 0.05
var baseCritDamage: float = 2.0
	
func _ready():
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.slashScale += 0.2
			2: 
				self.anis.append("pierce")
			3: self.slashScale += 0.4
			4:
				self.pierceCritRate = 1.0
				self.pierceCritDamage += 0.5
	
func attack():
	var target = get_global_mouse_position()
	var grabArea = grabScene.instantiate()
	self.player.add_child(grabArea)
	var direction: Vector2 = target - self.global_position
	var damage = calculate_damage()
	grabArea.init(direction)
	
func calculate_damage():
	return DamageInfo.new(
		self.baseDamage + 2 * self.level + 0.4 * self.player.strength, 0, 
		randf() < self.baseCritRate + self.player.critRate,
		self.baseCritDamage, player)
