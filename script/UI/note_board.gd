extends Control

@onready var textLabel = $Panel/MarginContainer/VBoxContainer/Label
@onready var buttonLabel = $Panel/MarginContainer/VBoxContainer/TextureButton/Label
signal click

var _resolved := false

func init(player: BasePlayer, cfg_dict: Dictionary = {}):
	textLabel.text = cfg_dict["text"]
	buttonLabel.text = cfg_dict["button_text"]

func _on_texture_button_pressed():
	_resolve()

func _resolve() -> void:
	if _resolved:
		return
	_resolved = true
	emit_signal("click")

func close_board():
	_resolve()
	queue_free()
