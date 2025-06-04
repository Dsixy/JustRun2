extends BaseWeapon

@export var dashScene: PackedScene

var attackInterval: float = 0.6
var baseDamage: int = 3

var baseCritRate: float = 0.05
var baseCritDamage: float = 2.0

var dashScale: float = 1.0
var dashTime: int = 1
	
func _ready():
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.baseDamage += 10
			2: 
				self.player.scale += Vector2.ONE * self.player.stamina * 0.1
			3: self.baseDamage += 20
			4:
				self.dashTime += 1

func attack():
	for i in range(dashTime):
		await attack_once()
		await get_tree().create_timer(0.35).timeout

func attack_once():
	if player.isDash:
		return
	var target = get_global_mouse_position()
	var direction: Vector2 = (target - self.global_position).normalized()

	var dash = dashScene.instantiate()
	player.add_child(dash)

	var damage = DamageInfo.new(calculate_damage(), 0, 
		randf() < self.baseCritRate + player.critRate,
		self.baseCritDamage, player)

	dash.init("dash", direction, damage, dashScale * 3)
	dash.extraVel = direction * 1500
	dash.scale /= 2

	player.direction = direction
	player.isDash = true
	player.isInvincible = true

	var tween = get_tree().create_tween()
	var original_speed = player.speed
	tween.tween_property(player, "speed", original_speed * 5, 0.1).set_ease(Tween.EASE_OUT)
	tween.tween_property(player, "speed", original_speed, 0.24).set_ease(Tween.EASE_IN)
	
func calculate_damage():
	return self.baseDamage + 4 * self.level + 2 * self.player.stamina
