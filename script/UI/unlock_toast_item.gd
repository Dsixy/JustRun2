extends Control

@onready var icon_rect: TextureRect = $Panel/MarginContainer/HBoxContainer/Icon
@onready var title_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/Title
@onready var subtitle_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/Subtitle

const DISPLAY_TIME := 2.4
const SLIDE_OFFSET := 72.0

var _rest_position: Vector2 = Vector2.ZERO

func setup(title: String, subtitle: String, icon: Texture2D) -> void:
	title_label.text = title
	subtitle_label.text = subtitle
	icon_rect.texture = icon

func play() -> void:
	_rest_position = position
	position.x = _rest_position.x - SLIDE_OFFSET
	modulate.a = 0.0

	var tween_in := create_tween()
	tween_in.set_parallel(true)
	tween_in.tween_property(self, "modulate:a", 1.0, 0.22)
	tween_in.tween_property(self, "position:x", _rest_position.x, 0.28)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween_in.finished

	await get_tree().create_timer(DISPLAY_TIME).timeout

	var tween_out := create_tween()
	tween_out.set_parallel(true)
	tween_out.tween_property(self, "modulate:a", 0.0, 0.18)
	tween_out.tween_property(self, "position:x", _rest_position.x - 32.0, 0.18)
	await tween_out.finished
	queue_free()
