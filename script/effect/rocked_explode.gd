extends HitArea

@onready var burningBuff = preload("res://scene/buff/burning_buff.tscn")
@onready var shape = $Area2D/CollisionShape2D
var burning: bool = false

func init(pos: Vector2, damage: DamageInfo, dur: float, radius: int, burning: bool):
	self.global_position = pos
	self.damage = damage
	self.shape.shape.radius = radius
	self.burning = burning
	await get_tree().create_timer(dur).timeout
	delete()
	
func delete():
	call_deferred("queue_free")
	
func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		var e = area.get_parent()
		e.be_hit(damage.copy())
		if burning:
			var buff = burningBuff.instantiate()
			buff.set_up(GameInfo.mainscene.player)
			e.buffManager.add_buff(buff)
