extends Control

const BOOK_SLOT_SCENE := preload("res://scene/UI/book_slot.tscn")
const WeaponHandbookCatalog = preload("res://script/UI/weapon_handbook_catalog.gd")
const ASSET_ATLAS := preload("res://asset/image/asset.png")

const CONSUMABLE_ENTRIES: Array[Dictionary] = [
	{
		"name": "升级套件",
		"description": "非武器。拖拽该物品到其他武器上后可升级该武器。",
		"atlas_region": Rect2(1000, 900, 100, 100),
	},
	{
		"name": "镜子",
		"description": "非武器。拖拽到武器上以复制该武器的一级版本。",
		"atlas_region": Rect2(1100, 900, 100, 100),
	},
	{
		"name": "彩虹糖",
		"description": "非武器。获取后自动使用，使角色天赋点 +1。",
		"atlas_region": Rect2(1200, 900, 100, 100),
	},
]

@onready var itemListBoard = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/GridContainer
@onready var showBoardTexture = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/PanelContainer/TextureRect
@onready var showBoardNameLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/PanelContainer2/VBoxContainer/Name
@onready var showBoardDespLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/PanelContainer2/VBoxContainer/Description

var _slots: Array[Control] = []

func init(_player: BasePlayer, _cfg_dict: Dictionary = {}) -> void:
	_populate_catalog()
	if not _slots.is_empty():
		_show_slot(_slots[0])

func _populate_catalog() -> void:
	for child in itemListBoard.get_children():
		child.queue_free()
	_slots.clear()

	GameInfo.sync_weapon_handbook_defaults()

	for entry in CONSUMABLE_ENTRIES:
		_add_slot({
			"name": entry["name"],
			"description": entry["description"],
			"texture": _atlas_texture(entry["atlas_region"]),
			"unlocked": true,
			"is_weapon": false,
		})

	var weapon_entries: Array[Dictionary] = []
	for weapon_path in GameInfo.get_all_weapon_scene_paths():
		var weapon: BaseWeapon = load(weapon_path).instantiate()
		var weapon_key := weapon_path.get_file().get_basename()
		var display_name := weapon.na if weapon.na != "" else WeaponHandbookCatalog.get_weapon_name(weapon_key, weapon_key)
		weapon_entries.append({
			"weapon_key": weapon_key,
			"name": display_name,
			"descriptions": WeaponHandbookCatalog.get_descriptions(weapon_key),
			"texture": weapon.texture,
			"unlocked": GameInfo.is_weapon_unlocked(weapon_key),
			"max_level": GameInfo.get_weapon_handbook_max_level(weapon_key),
			"is_weapon": true,
			"id": weapon.id,
		})
		weapon.free()

	weapon_entries.sort_custom(func(a, b): return a["id"] < b["id"])
	for entry in weapon_entries:
		_add_slot(entry)

	for slot in _slots:
		slot.connect("click", _on_sub_slot_clicked)

func _add_slot(entry: Dictionary) -> void:
	var slot: Control = BOOK_SLOT_SCENE.instantiate()
	itemListBoard.add_child(slot)
	slot.configure(entry)
	_slots.append(slot)

func _atlas_texture(region: Rect2) -> AtlasTexture:
	var atlas := AtlasTexture.new()
	atlas.atlas = ASSET_ATLAS
	atlas.region = region
	return atlas

func _on_sub_slot_clicked(node: Control) -> void:
	_show_slot(node)

func _show_slot(node: Control) -> void:
	showBoardTexture.texture = node.get_icon()
	showBoardNameLabel.text = node.get_display_name()
	showBoardDespLabel.text = node.get_display_description()

func close_board():
	queue_free()
