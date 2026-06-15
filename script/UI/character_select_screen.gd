extends Control

@onready var playerDisplayScene = preload("res://scene/UI/player_display.tscn")
@onready var container = $GridContainer
@onready var cheatButton = $CheatButton
var playerList = []

func _ready():
	GameInfo.cheat = cheatButton.button_pressed
	cheatButton.toggled.connect(_on_cheat_toggled)
	_refresh_player_list()

func _on_cheat_toggled(_pressed: bool) -> void:
	GameInfo.cheat = cheatButton.button_pressed
	_refresh_player_list()

func _refresh_player_list() -> void:
	var previous_path := GameInfo.player
	for player_display in playerList:
		player_display.queue_free()
	playerList.clear()

	var available_player := GameInfo.get_selectable_character_scene_paths()
	if available_player.is_empty():
		available_player = [GameInfo.CHARACTER_SCENES["aho"]]
	for player_path in available_player:
		register_player(player_path)

	if previous_path in available_player:
		GameInfo.player = previous_path
	else:
		GameInfo.player = available_player[0]
	_highlight_selected()

func _highlight_selected() -> void:
	for player_display in playerList:
		if player_display.playerPath == GameInfo.player:
			player_display.modulate = Color8(100, 100, 100)
		else:
			player_display.modulate = Color8(255, 255, 255)

func register_player(p: String):
	var playerDisplay = playerDisplayScene.instantiate()
	container.add_child(playerDisplay)
	playerDisplay.init(p)
	playerDisplay.connect("onclick", _on_player_clicked)
	playerList.append(playerDisplay)

func _on_texture_button_pressed():
	GameInfo.cheat = cheatButton.button_pressed
	get_tree().change_scene_to_file("res://scene/scene.tscn")

func _on_player_clicked(node: Control):
	_highlight_selected()
