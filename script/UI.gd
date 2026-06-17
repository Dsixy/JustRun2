extends CanvasLayer

const abilityBoardScene = preload("res://scene/UI/player_ability_board.tscn")
const weaponArmBoardScene = preload("res://scene/UI/weapon_arm_board.tscn")
const bagBoardScene = preload("res://scene/UI/bag_board.tscn")
const shopBoardScene = preload("res://scene/UI/shop_board.tscn")
const noteBoardScene = preload("res://scene/UI/note_board.tscn")
const illustratedHandbookScene = preload("res://scene/UI/illustrated_handbook.tscn")
const pauseMenuScene = preload("res://scene/UI/pause_menu.tscn")

@onready var container = $Container

# UI 栈，保存「一组 UI 名称」
var UIFocusStack: Array[Array] = []

# 当前打开的 UI 节点引用
var UIBoardDict := {
	"ability": null,
	"weapon_arm": null,
	"bag": null,
	"note": null,
	"shop": null,
	"book": null,
	"pause": null,
}

var player: BasePlayer

# 输入映射表：动作 -> 对应 UI 列表
var input_to_ui := {
	"OpenAbilityBoard": ["ability"],
	"OpenBag": ["bag", "weapon_arm"],  # 👈 bag 要和 weapon_arm 一起
	"OpenBook": ["book"],
	#"OpenNote": ["note"],
	"OpenShop": ["shop"]
}

# 把 UIFocusStack 展平成一维数组
func _flatten_stack() -> Array[String]:
	var result: Array[String] = []
	for group in UIFocusStack:
		for ui_name in group:
			result.append(ui_name)
	return result
	
# 根据 UI 名称返回场景
func _get_scene_by_name(ui_name: String) -> PackedScene:
	match ui_name:
		"bag": return bagBoardScene
		"ability": return abilityBoardScene
		"weapon_arm": return weaponArmBoardScene
		"note": return noteBoardScene
		"book": return illustratedHandbookScene
		"shop": return shopBoardScene
		"pause": return pauseMenuScene
		_: return null


func _game_shortcuts_blocked() -> bool:
	return "pause" in _flatten_stack()


# 输入处理
func _unhandled_input(event):
	if Input.is_action_just_pressed("ExitUI"):
		if not UIFocusStack.is_empty():
			_close_top_ui()
		elif GameInfo.is_run_active():
			_open_pause_menu()
		return

	if _game_shortcuts_blocked():
		return

	for action in input_to_ui.keys():
		if Input.is_action_just_pressed(action):
			_process_ui_signal(input_to_ui[action])


# 处理 UI 信号
func _process_ui_signal(ui_group: Array) -> void:
	if _game_shortcuts_blocked():
		return

	# 1. 如果栈顶就是这一组 UI → 关闭并弹栈
	if not UIFocusStack.is_empty() and UIFocusStack.back() == ui_group:
		_close_top_ui()
		return

	# 2. 如果栈中包含这一组 UI 的任意一个 → 忽略
	var existing := _flatten_stack()
	for ui_name in ui_group:
		if ui_name in existing:
			return

	# 3. 打开新的 UI 组并压栈
	_open_ui_group(ui_group)


# 打开 UI 组
func _open_ui_group(ui_group: Array, cfg_dict: Dictionary = {}) -> Array:
	var opened: Array[String] = []
	var instances: Array = []

	for ui_name in ui_group:
		var scene := _get_scene_by_name(ui_name)
		if not scene:
			continue

		var instance = scene.instantiate()
		container.add_child(instance)
		instance.init(player, cfg_dict)

		UIBoardDict[ui_name] = instance
		opened.append(ui_name)
		instances.append(instance)
		if ui_name == "pause" and instance.has_signal("closed"):
			instance.connect("closed", _close_top_ui)

	if opened.size() > 0:
		UIFocusStack.append(opened)
		get_tree().paused = true
		
	return instances


# 关闭栈顶 UI 组
func _close_top_ui() -> void:
	if UIFocusStack.is_empty():
		return

	var ui_group: Array[String] = UIFocusStack.pop_back()
	for ui_name in ui_group:
		if UIBoardDict[ui_name]:
			UIBoardDict[ui_name].close_board()
			UIBoardDict[ui_name] = null

	# 栈空了 → 恢复游戏
	if UIFocusStack.is_empty() and GameInfo.is_run_active():
		get_tree().paused = false


func _open_pause_menu() -> void:
	_open_ui_group(["pause"])


func force_close_all() -> void:
	while not UIFocusStack.is_empty():
		_close_top_ui()
	if GameInfo.is_run_active():
		get_tree().paused = false
