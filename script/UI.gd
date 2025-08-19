extends CanvasLayer

const abilityBoardScene = preload("res://scene/UI/player_ability_board.tscn")
const weaponArmBoardScene = preload("res://scene/UI/weapon_arm_board.tscn")
const bagBoardScene = preload("res://scene/UI/bag_board.tscn")
const shopBoardScene = preload("res://scene/UI/shop_board.tscn")
const noteBoardScene = preload("res://scene/UI/note_board.tscn")
const illustratedHandbookScene = preload("res://scene/UI/illustrated_handbook.tscn")

@onready var container = $Container
var UIFocusStack = []
var UIBoardDict = {
	"ability": null,
	"weapon_arm": null,
	"bag": null,
	"note": null,
	"shop": null,
	"book": null
}
var isBoardOpen: bool = false
var player: BasePlayer

# manage input
func _unhandled_input(event):
	if Input.is_action_just_pressed("OpenBag"):
		if UIBoardDict["bag"] and "bag" in UIFocusStack[-1]:
			UIFocusStack.pop_back()
			close_UI_board(["bag", "weapon_arm"])
		else:
			open_UI_board(["bag", "weapon_arm"])
	
	if Input.is_action_just_pressed("OpenAbilityBoard"):
		if UIBoardDict["ability"] and "ability" in UIFocusStack[-1]:
			UIFocusStack.pop_back()
			close_UI_board(["ability"])
		else:
			open_UI_board(["ability"])
			
	if Input.is_action_just_pressed("OpenBook"):
		if UIBoardDict["book"] and "book" in UIFocusStack[-1]:
			UIFocusStack.pop_back()
			close_UI_board(["book"])
		else:
			open_UI_board(["book"])
		
	if Input.is_action_just_pressed("ExitUI"):
		var focusUINames = UIFocusStack.pop_back()
		if focusUINames:
			close_UI_board(focusUINames)
			
	if UIFocusStack.is_empty() and not GameInfo.mainscene.gameoverFlag:
		get_tree().paused = false	

func open_UI_board(UIList: Array[String], cfg_dict: Dictionary = {}):
	var UIScenes: Array[String] = []
	var UISceneVar
	for UIName: String in UIList:
		match UIName:
			"bag": UISceneVar = bagBoardScene.instantiate()
			"ability": UISceneVar = abilityBoardScene.instantiate()
			"weapon_arm": UISceneVar = weaponArmBoardScene.instantiate()
			"note": UISceneVar = noteBoardScene.instantiate()
			"book": UISceneVar = illustratedHandbookScene.instantiate()
			"shop": UISceneVar = shopBoardScene.instantiate()
		
		container.add_child(UISceneVar)
		UISceneVar.init(player, cfg_dict)
		
		get_tree().paused = true
		UIScenes.append(UIName)
		UIBoardDict[UIName] = UISceneVar
			
	UIFocusStack.append(UIScenes)
	return UISceneVar
	
func close_UI_board(UIList: Array[String]):
	for UIName: String in UIList:
		if UIBoardDict[UIName]:
			UIBoardDict[UIName].close_board()
			UIBoardDict[UIName] = null
			
	if UIFocusStack.is_empty() and not GameInfo.mainscene.gameoverFlag:
		get_tree().paused = false

