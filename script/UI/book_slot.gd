extends PanelContainer

const HandbookText = preload("res://script/UI/handbook_text.gd")
const WeaponHandbookCatalog = preload("res://script/UI/weapon_handbook_catalog.gd")

@export var description: String
@export var item_name: String
@export var itemTexture: AtlasTexture

@onready var texture = $MarginContainer/TextureRect

var weapon_key: String = ""
var level_descriptions: Array[String] = []
var handbook_max_level: int = -1
var catalog_unlocked: bool = true
var is_weapon_entry: bool = false

signal click(node: Control)

func _ready():
	if itemTexture:
		texture.texture = itemTexture

func configure(entry: Dictionary) -> void:
	weapon_key = entry.get("weapon_key", "")
	is_weapon_entry = entry.get("is_weapon", weapon_key != "")
	item_name = entry.get("name", "")
	description = entry.get("description", "")
	level_descriptions = _resolve_level_descriptions(entry)
	handbook_max_level = entry.get("max_level", -1)
	catalog_unlocked = entry.get("unlocked", true)
	var tex: Texture2D = entry.get("texture")
	if tex:
		texture.texture = tex
	_apply_visual()

func _resolve_level_descriptions(entry: Dictionary) -> Array[String]:
	var weapon_key: String = entry.get("weapon_key", "")
	if weapon_key != "":
		var catalog_lines := WeaponHandbookCatalog.get_descriptions(weapon_key)
		if not catalog_lines.is_empty():
			return catalog_lines
	var raw: Array = entry.get("descriptions", [])
	return HandbookText.copy_string_array(raw)

func _apply_visual() -> void:
	modulate = Color8(255, 255, 255) if catalog_unlocked else Color8(100, 100, 100)

func get_display_name() -> String:
	if is_weapon_entry and not catalog_unlocked:
		return "未解锁"
	return item_name if item_name != "" else "？？？"

func get_display_description() -> String:
	if is_weapon_entry and not catalog_unlocked:
		return "？？？"
	if is_weapon_entry:
		return HandbookText.format_weapon_levels(level_descriptions, handbook_max_level)
	return description

func get_icon() -> Texture2D:
	return texture.texture

func _on_button_pressed():
	emit_signal("click", self)
