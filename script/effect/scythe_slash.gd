extends HitArea

var _explode_damage: DamageInfo

func init(pos: Vector2, direc: Vector2, hit_damage: DamageInfo, explode_amount: float = -1.0) -> void:
	global_position = pos
	rotation = direc.angle() + PI / 2
	damage = hit_damage
	_explode_damage = hit_damage.copy()
	if explode_amount >= 0.0:
		_explode_damage.baseAmount = explode_amount
	$Area2D.set_collision_mask_value(3, false)
	$Area2D.set_collision_mask_value(1, true)
	await get_tree().create_timer(0.6).timeout
	explode()

func explode() -> void:
	var players = $Area2D.get_overlapping_areas()
	for player in players:
		player.get_parent().take_damage(_explode_damage.copy())
	delete()

func delete() -> void:
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var e = area.get_parent()
		e.take_damage(damage.copy())
