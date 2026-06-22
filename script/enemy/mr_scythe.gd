extends BaseEnemy

## Boss 等级固定，数值为常量（与百科 enemies.md 一致）
const BOSS_LEVEL := 1
const BOSS_HP := 30000
const CONTACT_DAMAGE := 25
const BULLET_DAMAGE := 20
const RUSH_DAMAGE := 50
const SLASH_HIT_DAMAGE := 50
const SLASH_EXPLODE_DAMAGE := 100

const FrenzyBuffScene = preload("res://scene/buff/frenzy_buff.tscn")

@export var bulletScene: PackedScene
@export var slashScene: PackedScene
var isRush: bool = false
var bulletNum: int = 10
var bulletWave: int = 5
const shootAccuracy: float = 1
const bulletSpeed: int = 800
var bulletDamage: DamageInfo

func _ready() -> void:
	speed = 100
	reset_properties(0)

func _physics_process(delta: float) -> void:
	if not isRush:
		direction = (target - global_position).normalized()

	move_and_collide((direction * speed + extraVel) * delta)
	extraVel *= 0.95

func init(_level: int, wave: int) -> void:
	level = BOSS_LEVEL
	reset_properties(wave)

func reset_properties(_wave: int = 0) -> void:
	maxHP = BOSS_HP
	HP = BOSS_HP
	damage.baseAmount = CONTACT_DAMAGE
	bulletDamage = DamageInfo.new(BULLET_DAMAGE)

func rush() -> void:
	speed = 1500
	var prev_contact := damage.baseAmount
	damage.baseAmount = RUSH_DAMAGE
	isRush = true
	animationPlayer.play("Dash")
	await get_tree().create_timer(0.6).timeout
	animationPlayer.play("Move")
	speed = 100
	damage.baseAmount = prev_contact
	isRush = false

func slash() -> void:
	animationPlayer.play("Slash")
	await animationPlayer.animation_finished
	animationPlayer.play("Move")

	var s = slashScene.instantiate()
	var di := (target - global_position).normalized()
	var slash_damage := DamageInfo.new(SLASH_HIT_DAMAGE)
	GameInfo.mainscene.add_child(s)
	s.init(global_position + 500 * di, di, slash_damage, SLASH_EXPLODE_DAMAGE)

func shoot() -> void:
	animationPlayer.play("Idle")
	for _j in range(bulletWave):
		for i in range(bulletNum):
			var bullet = bulletScene.instantiate()
			var bullet_dir: Vector2 = Vector2.from_angle(
				(target - global_position).angle() + 0.2 * (i - bulletNum / 2)
			)
			var bias: Vector2 = bullet_dir.orthogonal() * (randf() * 2 - 1) * (1 - shootAccuracy)
			GameInfo.mainscene.add_child(bullet)
			bullet.init(global_position, bullet_dir + bias, bulletSpeed, bulletDamage, 1)
			bullet.modulate = Color8(255, 100, 100)
		await get_tree().create_timer(0.1).timeout
	animationPlayer.play("Move")

func shout() -> void:
	animationPlayer.play("Idle")
	var scene := GameInfo.get_run_scene()
	if scene != null and scene.get("enemies"):
		for enemy in scene.enemies:
			if not is_instance_valid(enemy) or enemy == self:
				continue
			var buff = FrenzyBuffScene.instantiate()
			buff.set_up(self)
			enemy.buffManager.add_buff(buff)
	await get_tree().create_timer(0.8).timeout
	animationPlayer.play("Move")

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	global_position = target + Vector2.from_angle(randf() * PI * 2) * 500

func _on_timer_timeout() -> void:
	var skills := ["rush", "shoot", "slash", "shout"]
	var skill: String = skills.pick_random()
	call(skill)
