extends HitArea

@onready var shape = $Area2D/CollisionShape2D
func init(pos: Vector2, damage: DamageInfo, dur: float, radius: int):
	self.global_position = pos
	self.damage = damage
	self.shape.shape.radius = radius
	await get_tree().create_timer(dur).timeout
	delete()
	
func delete():
	call_deferred("queue_free")
