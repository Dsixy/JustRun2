class_name HitArea extends Node2D

var damage: DamageInfo
var extraVel: Vector2 = Vector2.ZERO

func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		var e = area.get_parent()
		e.be_hit(damage.copy())
		e.extraVel = extraVel
