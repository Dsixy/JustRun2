extends HitArea

var lifeSteal: int = 0

@onready var aniplayer = $AnimationPlayer
func init(ani: String, direction: Vector2, damage: DamageInfo, scale: int):
	self.rotation = direction.angle()
	self.damage = damage
	self.scale *= scale
	aniplayer.play(ani)
	
func delete():
	call_deferred("queue_free")

func _on_animation_player_animation_finished(anim_name):
	delete()
	
func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		var e = area.get_parent()
		e.be_hit(damage.copy())
		e.be_knock_back(extraVel, 0.5)
		damage.source.HP += lifeSteal
