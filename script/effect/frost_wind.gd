extends HitArea

var range: float = 1.0
@onready var area = $Area2D
@onready var particle = $CPUParticles2D
@onready var frostBiteBuff = preload("res://scene/buff/frost_bite_buff.tscn")

func _ready():
	pass # Replace with function body.

func init(pos: Vector2, direction: Vector2, range: float, damage: DamageInfo):
	self.global_position = pos
	self.rotation = direction.angle()
	self.damage = damage
	self.range = range
	spread()
	
func spread():
	particle.emitting = true
	particle.initial_velocity_max *= self.range
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(area, "scale", Vector2.ONE * self.range * 3, 1.4)
	tween.tween_property(area, "position", Vector2(300, 0) * self.range, 1.4)
	tween.set_parallel(false)
	tween.tween_callback(queue_free)
	
func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		var enemy = area.get_parent()
		enemy.be_hit(damage.copy())
		var buff = frostBiteBuff.instantiate()
		buff.set_up(GameInfo.mainscene.player)
		enemy.buffManager.add_buff(buff)
