extends Control

signal click

var property_name: String
var description: String
var upgradeAva: bool = false
var value: int:
	set(val):
		bar.radial_fill_degrees = val * 18
		value = val

@onready var bar = $TextureProgressBar
@onready var sprite = $Sprite2D
@onready var panel = $PanelContainer

func init(pro: String, frame_idx: int, color, des: String="", val: int=0):
	property_name = pro
	description = des
	value = val
	sprite.frame = frame_idx
	bar.tint_progress = color
	$PanelContainer/MarginContainer/Label.text = des
	
func upgrade():
	value += 1

func set_available(a: bool):
	upgradeAva = a
	
func _on_button_pressed():
	if upgradeAva and value < 20:
		upgrade()
		emit_signal("click")

func _on_button_mouse_entered():
	panel.show()

func _on_button_mouse_exited():
	panel.hide()
