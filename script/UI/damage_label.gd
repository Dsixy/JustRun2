extends Label
signal end(label)

const DamageTypes = preload("res://script/damage_types.gd")

func init(damage: DamageInfo, pos: Vector2):
	self.text = str(damage.finalDamage)
	if damage.isCrit:
		self.text += '!'
		self.scale = Vector2(1.2, 1.2)
	self.global_position = pos
	self.modulate = DamageTypes.color(damage.damageType)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(0, -50), 0.5)
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)

func init_text(text: String, pos: Vector2, color: Color = Color8(255, 255, 0)) -> void:
	self.text = text
	self.global_position = pos
	self.modulate = color
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(0, -50), 0.5)
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)
