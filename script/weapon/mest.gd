extends BaseWeapon

@export var dashScene: PackedScene

var attackInterval: float = 0.6

var baseCritRate: float = 0.05
var baseCritDamage: float = 2.0

var dashScale: float = 1.0
var heal: int = 0
var dashTime: int = 1
	
func _ready():
	self.baseDamage = [8, 15, 30, 70, 180]
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.heal = 1
			2:
				if player and not player.mest_body_scale_applied:
					player.scale += Vector2.ONE * player.stamina * 0.1
					player.mest_body_scale_applied = true
			3: self.heal = 3
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
		randf() < self.baseCritRate + player.critRate + 0.03 * self.player.resilience,
		self.baseCritDamage, player)

	var body_scale := maxf(player.scale.x, player.scale.y)
	dash.init("dash", direction, damage, dashScale * 3 * body_scale)
	dash.extraVel = direction * 1200
	dash.scale /= 2
	dash.scale *= body_scale
	dash.lifeSteal = heal

	player.direction = direction
	player.isDash = true
	player.isInvincible = true

	var tween = get_tree().create_tween()
	var original_speed = player.speed
	tween.tween_property(player, "speed", original_speed * 5, 0.1).set_ease(Tween.EASE_OUT)
	tween.tween_property(player, "speed", original_speed, 0.24).set_ease(Tween.EASE_IN)
	
func calculate_damage():
	return self.baseDamage[self.level] + 10 * self.player.stamina * self.level
