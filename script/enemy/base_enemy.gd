class_name BaseEnemy extends CharacterBody2D

@onready var animationPlayer = $AnimationPlayer
@onready var buffManager = $BuffManager
@onready var statusIcon = $StatusIcon
@onready var stateMachine = $StateMachine
var target: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var extraVel: Vector2 = Vector2.ZERO
var staggerTime: float = 0.0
var speed: int = 100
var HP: int = 100
var damage: DamageInfo = DamageInfo.new()
var level: int = 1

const WAVE_SCALE: Array[int] = [1, 2, 4, 8, 12, 24, 30, 36, 44, 50]

signal death(sender: BaseEnemy, pos: Vector2, willLoot: bool)

func _ready():
	damage.baseAmount = 5.0
	
func _physics_process(_delta):
	stateMachine.physics_process(_delta)
	#direction = (target - global_position).normalized()
	#velocity = direction * speed + extraVel
	#move_and_collide(velocity * _delta)
	#extraVel *= 0.95
	
func be_knock_back(knockVel: Vector2, time: float):
	self.extraVel = knockVel
	self.staggerTime = time
	
	self.stateMachine.switch_to_state("Staggered")
	
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
