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

	for character_key in GameInfo.CHARACTER_ORDER:
		var player_path: String = GameInfo.CHARACTER_SCENES[character_key]
		var unlocked := GameInfo.cheat or GameInfo.is_character_unlocked(character_key)
		register_player(player_path, unlocked)

	_ensure_valid_selection(previous_path)
	_highlight_selected()

func _ensure_valid_selection(previous_path: String) -> void:
	var selectable := GameInfo.get_selectable_character_scene_paths()
	if selectable.is_empty():
		GameInfo.player = GameInfo.CHARACTER_SCENES["aho"]
	elif previous_path in selectable:
		GameInfo.player = previous_path
	else:
		GameInfo.player = selectable[0]

func _highlight_selected() -> void:
	for player_display in playerList:
		player_display.set_highlight(player_display.playerPath == GameInfo.player)

func register_player(p: String, unlocked: bool) -> void:
	var playerDisplay = playerDisplayScene.instantiate()
	container.add_child(playerDisplay)
	playerDisplay.init(p, not unlocked)
	playerDisplay.connect("onclick", _on_player_clicked)
	playerList.append(playerDisplay)

func _on_texture_button_pressed():
	GameInfo.cheat = cheatButton.button_pressed
	get_tree().change_scene_to_file("res://scene/scene.tscn")

func _on_player_clicked(node: Control) -> void:
	if node.is_locked:
		return
	GameInfo.player = node.playerPath
	_highlight_selected()
