extends HitArea

const DamageTypes = preload("res://script/damage_types.gd")

var maxRadius: int = 400

func init(pos: Vector2, radiusBonus: float, damageAmount: int,
		p_crit_rate: float = 0.05, p_crit_damage: float = 1.5, source: Node = null):
	global_position = pos
	self.damage = DamageInfo.new(damageAmount, 0,
				randf() < p_crit_rate, p_crit_damage, source, DamageTypes.PSYCHIC)
	self.maxRadius = 5 * (1 + radiusBonus)
	spread()
				
func spread():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * maxRadius, 0.6)
	tween.tween_callback(queue_free)
