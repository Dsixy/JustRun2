extends HitArea

var maxRadius: int = 400

func init(pos: Vector2, radiusBonus: float, damageAmount: int):
	global_position = pos
	self.damage = DamageInfo.new(damageAmount, 0,
				false, 1.5, null, "Psychic")
	self.maxRadius = 5 * (1 + radiusBonus)
	spread()
				
func spread():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * maxRadius, 0.6)
	tween.tween_callback(queue_free)
