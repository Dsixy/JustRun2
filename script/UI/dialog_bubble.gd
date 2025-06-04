extends Control

@onready var label = $PanelContainer/MarginContainer/VBoxContainer/Label
@onready var button_container = $PanelContainer/MarginContainer/VBoxContainer
var total_cfg

signal dialog_completed
	
func init(pos: Vector2, t: DialogRes):
	total_cfg = t
	global_position = pos
	reset(total_cfg.dialog[0])
	
func reset(cfg: Dialog):
	for child in button_container.get_children():
		if child != label:
			child.queue_free()

	label.text = cfg.text

	for choice in cfg.choice:
		var b = Button.new()
		b.text = choice.text
		
		var next_cfg
		if choice.next_id != -1:
			next_cfg = total_cfg.dialog[choice.next_id]
		else:
			next_cfg = {}
		b.set_meta("cfg", next_cfg)
		b.custom_minimum_size = Vector2(40, 40)
		b.pressed.connect(func(): next_bubble(b.get_meta("cfg")))
		button_container.add_child(b)

func next_bubble(cfg):
	if cfg is Dialog:
		reset(cfg)
	else:
		over()
		
func over():
	emit_signal("dialog_completed")
	queue_free()
