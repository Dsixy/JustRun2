extends PanelContainer

@export var description: String
@export var item_name: String
@export var itemTexture: AtlasTexture

@onready var texture = $MarginContainer/TextureRect

signal click(node: Control)

func _ready():
	texture.texture = itemTexture
	
func _on_button_pressed():
	emit_signal("click", self)
