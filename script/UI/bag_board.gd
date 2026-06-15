extends Control

var player: BasePlayer
var itemList = []
var slotList
var _debug_status_label: Label
var _debug_weapon_paths: Array[String] = []

func _ready():
	pass # Replace with function body.

func init(player: BasePlayer, cfg_dict: Dictionary = {}):
	self.player = player
	self.slotList = $Panel/HBoxContainer.get_children()
	
	for i in range(len(player.inventory)):
		itemList.append(player.inventory[i])
		self.slotList[i].set_type("bag")
		self.slotList[i].add_item(player.inventory[i])

	if GameInfo.cheat:
		_setup_debug_sidebar()
		
func _setup_debug_sidebar() -> void:
	_debug_weapon_paths = GameInfo.get_all_weapon_scene_paths()

	var panel = Panel.new()
	panel.name = "DebugWeaponSidebar"
	panel.set_anchors_preset(Control.PRESET_TOP_LEFT)
	panel.anchor_bottom = 1.0
	panel.offset_left = 8.0
	panel.offset_top = 48.0
	panel.offset_right = 300.0
	panel.offset_bottom = -200.0

	var margin = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_bottom", 10)
	panel.add_child(margin)

	var root = VBoxContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_child(root)

	var title = Label.new()
	title.text = "作弊 · 武器"
	title.add_theme_font_size_override("font_size", 22)
	root.add_child(title)

	_debug_status_label = Label.new()
	_debug_status_label.text = "点击名称装入背包"
	_debug_status_label.add_theme_font_size_override("font_size", 16)
	_debug_status_label.add_theme_color_override("font_color", Color(0.85, 0.85, 0.85))
	root.add_child(_debug_status_label)

	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root.add_child(scroll)

	var list = VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list)

	for path in _debug_weapon_paths:
		var sample = load(path).instantiate()
		var btn = Button.new()
		btn.text = sample.na if sample.na else path.get_file().get_basename()
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		sample.queue_free()
		btn.pressed.connect(_spawn_weapon_to_bag.bind(path))
		list.add_child(btn)

	add_child(panel)

func _spawn_weapon_to_bag(weapon_path: String) -> void:
	var idx = player.get_empty_inventory_idx()
	if idx == -1:
		if _debug_status_label:
			_debug_status_label.text = "背包已满"
		return

	var weapon = load(weapon_path).instantiate()
	player.inventory[idx] = weapon
	slotList[idx].add_item(weapon)
	itemList[idx] = weapon
	if _debug_status_label:
		var name_text = weapon.na if weapon.na else weapon_path.get_file().get_basename()
		_debug_status_label.text = "已添加：%s" % name_text
		
func close_board():
	for i in range(len(self.slotList)):
		player.inventory[i] = self.slotList[i].current_item
		
	queue_free()
