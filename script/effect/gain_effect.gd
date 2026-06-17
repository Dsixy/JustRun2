extends Control

@onready var sprite = $Sprite2D
var angVel: float = 1
signal click

var _resolved := false

func _process(delta):
	sprite.rotation += delta * angVel

func _on_button_pressed():
	_resolve()

func _resolve() -> void:
	if _resolved:
		return
	_resolved = true
	emit_signal("click")

func close_board() -> void:
	_resolve()
	queue_free()
