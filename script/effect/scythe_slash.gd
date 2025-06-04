extends HitArea

func init(pos: Vector2, direc: Vector2, damage: DamageInfo):
	self.global_position = pos
	self.rotation = direc.angle() + PI / 2
	self.damage = damage
	$Area2D.set_collision_mask_value(3, false)
	$Area2D.set_collision_mask_value(1, true)
	await get_tree().create_timer(0.6).timeout
	explode()
	
func explode():
	var players = $Area2D.get_overlapping_areas()
	for player in players:
		player.get_parent().take_damage(damage.copy())
	delete()
	
func delete():
	queue_free()
	
func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		var e = area.get_parent()
		e.take_damage(damage.copy())
