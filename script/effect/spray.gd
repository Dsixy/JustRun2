extends HitArea

var range: float = 1.0
var speed: int = 400
var extraDamage: float = 0
@onready var area = $Area2D
@onready var particle = $GPUParticles2D
@onready var frostBiteBuff = preload("res://scene/buff/poison_buff.tscn")

func init(pos: Vector2, direction: Vector2, range: float, speed: int, damage: DamageInfo, extraDamage: float):
	self.global_position = pos
	self.rotation = direction.angle()
	self.damage = damage
	self.range = range
	self.speed = speed
	self.extraDamage = extraDamage
	spread()
	
func spread():
	particle.process_material.initial_velocity_min = 400 * self.range
	particle.process_material.scale_min = 0.6 * self.range
	particle.process_material.scale_max = 0.8 * self.range
	particle.lifetime = 400.0 / speed
	particle.emitting = true
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(area, "scale", Vector2.ONE * self.range * 4, 400.0 / speed)
	tween.tween_property(area, "position", Vector2(180, 0) * self.range, 400.0 / speed)
	tween.set_parallel(false)
	tween.tween_callback(queue_free)
	
func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		var enemy = area.get_parent()
		enemy.be_hit(damage)
		var buff = frostBiteBuff.instantiate()
		buff.set_up(GameInfo.mainscene.player)
		buff.damage.baseAmount += extraDamage
		enemy.buffManager.add_buff(buff)
