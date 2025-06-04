extends Control

@onready var sprite = $Sprite2D
var angVel: float = 1
signal click

func _process(delta):
	sprite.rotation += delta * angVel

func _on_button_pressed():
	emit_signal("click")
