class_name BasePlayer extends CharacterBody2D

const expRequire = [20, 50, 100, 200, 300, 500, 600, 700, 800, 1000, 
					1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000,
					2500, 3000, 3500, 4000, 4500, 5000, 6000, 7000, 8000, 9000, 10000]
					
const expGemValue = [10, 50, 500]

var id: int

var stamina: int = 0
var strength: int = 0
var insight: int = 0
var agility: int = 0
var charisma: int = 0
var perception: int = 0
var resilience: int = 0
var dexterrity: int = 0
var level: int = 0

var abilityPoint: int = 0

var maxHP: int
var HP: int
var armor: int
var speed: int
var goldBonus: float = 1.0
var expBonus: float = 1.0
var critRate: float = 0.05
var pickupRange: int

var expValue: int
var direction: Vector2

@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $Sprite
@onready var pickupAreaShape = $PickupArea/CollisionShape2D
@onready var timer = $Timer
@onready var hurtbox = $Hurtbox
@onready var camera = $Camera2D
@onready var buffManager = $BuffManager

var weaponArm: BaseWeaponArm
var money: float = 0
var inventory = [null, null, null, null, null, null, null]
var isInvincible: bool = false
var refreshTime: int = 1
var isDash: bool = false
var elapse: float = 0.0
var dashTime: float = 0.3
var autoAttack: bool = true

signal get_upgrade
signal go_die

func _physics_process(_delta):
	if isDash:
		elapse += _delta
		if elapse >= dashTime:
			isDash = false
			elapse = 0.0
			isInvincible = false
	else:
		process_input()
		
		if not direction.is_zero_approx():
			animationPlayer.play("move")
		else:
			animationPlayer.play("idle")

	velocity = direction * speed
	move_and_slide()
	
func process_input():
	if GameInfo.mainscene.player != self:
		return
		
	direction = Vector2(0, 0)
	if Input.is_action_pressed("MoveUp"):
		direction.y = -1
	if Input.is_action_pressed("MoveDown"):
		direction.y = 1
	if Input.is_action_pressed("MoveLeft"):
		direction.x = -1
		sprite.scale = Vector2(-1, 1)
	if Input.is_action_pressed("MoveRight"):
		direction.x = 1
		sprite.scale = Vector2(1, 1)
	
	direction = direction.normalized()
		
func _unhandled_input(event):
	if GameInfo.mainscene.player != self:
		return
		
	if event.is_action_pressed("Attack") or autoAttack:
		weaponArm.activate()
	elif event.is_action_released("Attack"):
		weaponArm.deactivate()

func init(pos: Vector2):
	global_position = pos
	add_child(self.weaponArm)
	
	self.weaponArm.player = self
	self.weaponArm.update_weapons()
	init_stats()
	
func init_stats():
	pass
	
# update stats
func update():
	pass

func pick(area):
	_on_pickup_area_area_entered(area)
# pick up 
func _on_pickup_area_area_entered(area):
	var item = area.get_parent()
	var tween = get_tree().create_tween()
	tween.tween_property(item, "global_position", self.global_position, 0.15).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(item.queue_free)
	if area.is_in_group("expGem"):
		var value = self.expGemValue[item.level] * (1 + self.expBonus)
		gain_exp(value)
	elif area.is_in_group("coin"):
		gain_coin()
	elif area.is_in_group("flower"):
		item.on_picked_up(self)
		for weapon in self.weaponArm.weaponList:
			if weapon and weapon.id == 16:
				weapon.gain(item.n)
		
func gain_exp(exp: int):
	if self.level < 29:
		self.expValue += exp
		while(self.expValue >= self.expRequire[self.level]):
			self.expValue -= self.expRequire[self.level]
			upgrade()

func gain_coin(value: float = 1, extra: float = 0.0):
	self.money += (self.goldBonus + 1) * value + extra

func upgrade():
	self.level += 1
	self.level = min(30, self.level)
	self.abilityPoint += 2
	self.HP += int(self.maxHP * 0.1)
	emit_signal("get_upgrade")
	update()
	
func take_damage(damage: DamageInfo):
	damage = buffManager.modify_damage(damage)
	if not isInvincible and damage.baseAmount >= 1:
		isInvincible = true
		timer.start(0.6)
		self.HP -= 100.0 / (100 + self.armor) * damage.finalDamage
		if self.HP <= 0:
			dead()

func dead():
	emit_signal("go_die")
	
func get_empty_inventory_idx():
	for i in range(len(self.inventory)):
		if inventory[i] == null:
			return i
	return -1

func _on_timer_timeout():
	self.isInvincible = false
