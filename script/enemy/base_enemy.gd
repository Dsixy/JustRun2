class_name BaseEnemy extends CharacterBody2D

const DamageTypes = preload("res://script/damage_types.gd")
const LightningBuffScene = preload("res://scene/buff/lightning_buff.tscn")
const WeakenBuffScene = preload("res://scene/buff/weaken_buff.tscn")
const BuffElementReactions = preload("res://script/buff/buff_element_reactions.gd")

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
var maxHP: int = 100
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
	var hit_damage := damage.copy()
	var reaction_ctx := BuffElementReactions.apply(self, hit_damage)
	hit_damage = reaction_ctx.damage
	hit_damage = buffManager.modify_damage(hit_damage)
	Utils.show_damage_label(hit_damage, global_position + Vector2.UP * 50)
	HP -= hit_damage.finalDamage
	_try_apply_lightning_buff(hit_damage, reaction_ctx)
	_try_apply_weaken_buff(hit_damage)
	if HP <= 0:
		dead()

func _apply_bonus_damage(damage: DamageInfo) -> void:
	Utils.show_damage_label(damage, global_position + Vector2.UP * 50)
	HP -= damage.finalDamage
	if HP <= 0:
		dead()

func _try_apply_lightning_buff(damage: DamageInfo, reaction_ctx = null) -> void:
	if not damage.apply_lightning_buff:
		return
	if DamageTypes.normalize(damage.damageType) != DamageTypes.LIGHTNING:
		return
	var source = damage.source
	if source == null:
		var scene := GameInfo.get_run_scene()
		if scene and scene.get("player"):
			source = scene.player
	if source == null:
		return
	var buff = LightningBuffScene.instantiate()
	buff.set_up(source)
	if reaction_ctx:
		if reaction_ctx.lightning_chain_range > 0.0:
			buff.chain_range = reaction_ctx.lightning_chain_range
		if reaction_ctx.lightning_max_targets > 0:
			buff.max_chain_targets = reaction_ctx.lightning_max_targets
		if reaction_ctx.spread_burning_stacks > 0:
			buff.spread_burning_stacks = reaction_ctx.spread_burning_stacks
	buffManager.add_buff(buff)

func _try_apply_weaken_buff(damage: DamageInfo) -> void:
	if not damage.isCrit:
		return
	if DamageTypes.normalize(damage.damageType) != DamageTypes.PSYCHIC:
		return
	var source = damage.source
	if source == null:
		var scene := GameInfo.get_run_scene()
		if scene and scene.get("player"):
			source = scene.player
	var buff = WeakenBuffScene.instantiate()
	buff.set_up(source)
	buffManager.add_buff(buff)
	
func dead(willLoot: bool = true):
	emit_signal("death", self, global_position, willLoot)

func _on_hitbox_area_entered(area):
	area.get_parent().take_damage(damage)

func _on_visible_on_screen_notifier_2d_screen_exited():
	dead(false)
