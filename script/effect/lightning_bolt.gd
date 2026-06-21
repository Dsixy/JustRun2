extends Node2D

const DamageTypes = preload("res://script/damage_types.gd")

var _lifetime := 0.22

func init(from: Vector2, to: Vector2, segments: int = 7) -> void:
	top_level = true
	global_position = Vector2.ZERO
	z_index = 20

	var core := Line2D.new()
	core.points = _jagged_points(from, to, segments)
	core.width = 3.0
	core.default_color = DamageTypes.color(DamageTypes.LIGHTNING)
	core.antialiased = true
	add_child(core)

	var glow := Line2D.new()
	glow.points = _jagged_points(from, to, maxi(segments - 2, 4))
	glow.width = 8.0
	glow.default_color = Color(0.7, 0.85, 1.0, 0.35)
	glow.antialiased = true
	add_child(glow)
	move_child(glow, 0)

	modulate = Color(1, 1, 1, 1)
	var tween := get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.0, _lifetime)
	tween.tween_property(core, "width", 1.0, _lifetime)
	tween.set_parallel(false)
	tween.tween_callback(queue_free)

func _jagged_points(a: Vector2, b: Vector2, segments: int) -> PackedVector2Array:
	var points := PackedVector2Array()
	var direction := b - a
	var length := direction.length()
	if length < 1.0:
		points.append(a)
		points.append(b)
		return points
	var normal := direction.orthogonal() / length
	for i in range(segments + 1):
		var t := float(i) / float(segments)
		var point := a.lerp(b, t)
		if i > 0 and i < segments:
			point += normal * randf_range(-14.0, 14.0)
		points.append(point)
	return points
