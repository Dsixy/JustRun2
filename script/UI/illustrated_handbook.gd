extends Control

@onready var itemListBoard = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/GridContainer
@onready var showBoardTexture = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/PanelContainer/TextureRect
@onready var showBoardNameLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/PanelContainer2/VBoxContainer/Name
@onready var showBoardDespLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/PanelContainer2/VBoxContainer/Description
var timer: float = 0.0

func _ready():
	for itemSlot in itemListBoard.get_children():
		itemSlot.connect("click", _on_sub_slot_clicked)

func init(player: BasePlayer, cfg_dict: Dictionary = {}):
	pass
	
func _process(delta):
	timer += delta
	if timer >= 1.0:
		timer -= 1.0

func _on_sub_slot_clicked(node: Control):
	showBoardTexture.texture = node.itemTexture
	showBoardNameLabel.text = str(node.item_name)
	showBoardDespLabel.text = str(node.description)
	
func close_board():
	queue_free()
