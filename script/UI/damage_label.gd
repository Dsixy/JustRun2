extends Label
signal end(label)

const type2color = {
	"": Color8(255, 255, 0),
	"Poison": Color8(0, 255, 0),
	"Fire": Color8(255, 0, 0),
	"Ice": Color8(0, 0, 255),
	"Lightning": Color8(0, 150, 255),
	"Psychic": Color8(255, 150, 200),
}

func init(damage: DamageInfo, pos: Vector2):
	self.text = str(damage.finalDamage)
	if damage.isCrit:
		self.text += '!'
		self.scale = Vector2(1.2, 1.2)
	self.global_position = pos
	self.modulate = type2color[damage.damageType]
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(0, -50), 0.5)
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)
