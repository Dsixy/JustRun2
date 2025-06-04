extends HitArea

@onready var buffScene = preload("res://scene/buff/burning_buff.tscn")
var laserScale: float = 1.0
func init(direction: Vector2, damage: DamageInfo, laserScale: float):
	self.rotation = direction.angle()
	self.damage = damage
	self.scale = Vector2(20, 0)
	self.laserScale = laserScale
	attack()
	
func attack():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale:y", laserScale, 0.1)
	tween.tween_property(self, "scale:y", 0, 0.3).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)

func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		var e = area.get_parent()
		e.be_hit(damage.copy())
		#var buff = buffScene.instantiate()
		#buff.set_up(GameInfo.mainscene.player)
		#e.buffManager.add_buff(buff)
		
