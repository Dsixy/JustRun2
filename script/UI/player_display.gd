extends Control

@onready var content = $Panel/Control
var player: BasePlayer
var playerPath: String

func init(p: String):
	self.player = load(p).instantiate()
	self.playerPath = p
	content.add_child(player)
	process_player()
	
func process_player():
	if player:
		player.set_physics_process(false)
		player.set_process(false)
		player.camera.enabled = false

func _on_button_pressed():
	GameInfo.player = playerPath
