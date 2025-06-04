extends Node2D

@export var bulletScene: PackedScene
@onready var animationPlayer = $AnimationPlayer
@onready var area = $Area2D

var attackInterval: float = 0.6
var radiusBonus: float = 1
var elapse:= 0.0
var target: Node2D

var critRate: float = 0.0
var critDamage: float = 2.0
var baseDamage: int = 0

var pierce: bool = false
signal disappear(t: Node)

func _process(delta):
	elapse += delta
	if elapse >= attackInterval:
		elapse -= attackInterval
		shot()
		
func init(pos: Vector2, radiusBonus: float, attackInterval: float, critRate: float,
	critDamage: float, damage: int, pierce: bool ):
	self.global_position = pos
	self.radiusBonus = radiusBonus
	self.attackInterval = attackInterval
	self.critDamage = critDamage
	self.critRate = critRate
	self.baseDamage = damage
	self.pierce = pierce
	$Area2D/CollisionShape2D.shape.radius = radiusBonus * 350
	
func shot():
	if is_instance_valid(self.target):
		var b = bulletScene.instantiate()
		GameInfo.mainscene.bulletNode.add_child(b)
		
		var damage = DamageInfo.new(
			baseDamage, 0, randf() < critRate, critDamage, self
		)
		var direction = (target.global_position - global_position).normalized()
		b.init(global_position, direction, 1200, damage, 500 * radiusBonus, pierce)
		
		if (target.global_position - global_position).length() > 500 * radiusBonus:
			get_target()
	else:
		get_target()

func get_target():
	var enemies:Array = area.get_overlapping_areas()
	target = enemies.pick_random()
	if target:
		target = target.get_parent()

func delete():
	disappear.emit(self)
	queue_free()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	delete()
