extends Control

@onready var textLabel = $Panel/MarginContainer/VBoxContainer/Label
@onready var buttonLabel = $Panel/MarginContainer/VBoxContainer/TextureButton/Label
signal click

func _ready():
	pass # Replace with function body.

func init(player: BasePlayer, cfg_dict: Dictionary = {}):
	textLabel.text = cfg_dict["text"]
	buttonLabel.text = cfg_dict["button_text"]

func _on_texture_button_pressed():
	emit_signal("click")

func close_board():
	pass
