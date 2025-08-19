extends Control

var availablePlayer = [
	"res://scene/player/aho.tscn", 
	"res://scene/player/carmor.tscn",
	"res://scene/player/alew.tscn",
	#"res://scene/player/forgetfulness.tscn",
	#"res://scene/player/strongwoman.tscn"
]
@onready var playerDisplayScene = preload("res://scene/UI/player_display.tscn")
@onready var container = $GridContainer
@onready var cheatButton = $CheatButton
var playerList = []

func _ready():
	for player in availablePlayer:
		register_player(player)

func register_player(p: String):
	var playerDisplay = playerDisplayScene.instantiate()
	container.add_child(playerDisplay)
	playerDisplay.init(p)
	playerDisplay.connect("onclick", _on_player_clicked)
	playerList.append(playerDisplay)

func _on_texture_button_pressed():
	GameInfo.cheat= cheatButton.button_pressed
	get_tree().change_scene_to_file("res://scene/scene.tscn")

func _on_player_clicked(node: Control):
	for player in playerList:
		player.modulate = Color8(255, 255, 255)
	node.modulate = Color8(100, 100, 100)
