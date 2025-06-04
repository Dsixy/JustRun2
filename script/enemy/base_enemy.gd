class_name BaseEnemy extends CharacterBody2D

@onready var animationPlayer = $AnimationPlayer
@onready var buffManager = $BuffManager
@onready var statusIcon = $StatusIcon
var target: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var extraVel: Vector2 = Vector2.ZERO
var speed: int = 100
var HP: int = 100
var damage: DamageInfo = DamageInfo.new()
var level: int = 1

signal death(sender: BaseEnemy, pos: Vector2, willLoot: bool)

func _ready():
	damage.baseAmount = 5.0
	
func _physics_process(_delta):
	direction = (target - global_position).normalized()
	velocity = direction * speed + extraVel
	move_and_collide(velocity * _delta)
	extraVel *= 0.95
	
func reset_properties():
	pass
	
func update_target(goal: Vector2):
	target = goal
	
func be_hit(damage: DamageInfo):
	damage = buffManager.modify_damage(damage)
	Utils.show_damage_label(damage, global_position + Vector2.UP * 50)
	HP -= damage.finalDamage
	if HP <= 0:
		dead()
	
func dead(willLoot: bool = true):
	emit_signal("death", self, global_position, willLoot)

func _on_hitbox_area_entered(area):
	area.get_parent().take_damage(damage)

func _on_visible_on_screen_notifier_2d_screen_exited():
	dead(false)
