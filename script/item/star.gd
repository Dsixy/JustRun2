extends Node2D

@export var explodeScene: PackedScene
@onready var sprite = $Sprite2D
@onready var partical = $CPUParticles2D
var damage: DamageInfo
var radius: int = 0
var target_pos: Vector2

func _ready():
	sprite.scale = Vector2(0.1, 0.1)
	fall(Vector2(400, 500))

func fall(target_pos: Vector2, dur: float = 2.0):
	var tween = create_tween()
	var fall_bias = Vector2(randf_range(-300, 300), -1000) 
	partical.direction = fall_bias
	tween.set_parallel()
	global_position = fall_bias + target_pos
	rotation_degrees = 0

	tween.tween_property(self, "global_position", target_pos, dur).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(sprite, "rotation_degrees", 360 * 3, dur).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(sprite, "scale", Vector2(1.5, 1.5), dur)
	
	tween.set_parallel(false)
	tween.tween_callback(on_ground)
	
func on_ground():
	var explode = explodeScene.instantiate()
	GameInfo.add_child(explode)
	explode.init(target_pos, damage, 0.3, radius)
	queue_free()
	
func init(target_pos: Vector2, radius: int, damage: DamageInfo):
	self.damage = damage
	self.radius = radius
	self.target_pos = target_pos
	self.fall(target_pos)
