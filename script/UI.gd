extends CanvasLayer

signal open_bag_board
signal open_ability_board
signal close_board
var isBoardOpen: bool = false

func _process(delta):
	process_input()

func process_input():
	if Input.is_action_just_pressed("OpenBag"):
		if not isBoardOpen:
			emit_signal("open_bag_board")
			isBoardOpen = true
		else:
			emit_signal("close_board")
			isBoardOpen = false
			
	if Input.is_action_just_pressed("OpenAbilityBoard"):
		if not isBoardOpen:
			emit_signal("open_ability_board")
			isBoardOpen = true
		else:
			emit_signal("close_board")
			isBoardOpen = false
		
