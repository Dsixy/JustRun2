extends Node

const ToastScene := preload("res://scene/UI/unlock_toast_item.tscn")
const AssetAtlas := preload("res://asset/image/asset.png")

var _queue: Array[Dictionary] = []
var _showing := false
var _layer: CanvasLayer
var _anchor: Control

func _ready() -> void:
	_layer = CanvasLayer.new()
	_layer.layer = 90
	_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_layer)

	_anchor = Control.new()
	_anchor.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	_anchor.offset_left = 24.0
	_anchor.offset_top = -180.0
	_anchor.offset_right = 400.0
	_anchor.offset_bottom = -52.0
	_anchor.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_layer.add_child(_anchor)

func enqueue_weapon(weapon_key: String) -> void:
	_enqueue({
		"title": "武器解锁",
		"subtitle": _weapon_display_name(weapon_key),
		"icon": _weapon_icon(weapon_key),
	})

func enqueue_character(character_key: String) -> void:
	_enqueue({
		"title": "角色解锁",
		"subtitle": _character_display_name(character_key),
		"icon": _character_icon(character_key),
	})

func enqueue_achievement(title: String, subtitle: String, icon: Texture2D = null) -> void:
	_enqueue({
		"title": title,
		"subtitle": subtitle,
		"icon": icon if icon else _achievement_icon(),
	})

func wait_until_idle() -> void:
	while _showing or not _queue.is_empty():
		await get_tree().process_frame

func _enqueue(item: Dictionary) -> void:
	_queue.append(item)
	if not _showing:
		_process_queue()

func _process_queue() -> void:
	if _queue.is_empty():
		_showing = false
		return
	_showing = true
	var item: Dictionary = _queue.pop_front()
	_show_one_and_continue(item)

func _show_one_and_continue(item: Dictionary) -> void:
	var toast: Control = ToastScene.instantiate()
	_anchor.add_child(toast)
	toast.setup(item["title"], item["subtitle"], item["icon"])
	await toast.play()
	_process_queue()

func _weapon_display_name(weapon_key: String) -> String:
	var path := "res://scene/weapon/%s.tscn" % weapon_key
	if ResourceLoader.exists(path):
		var weapon: BaseWeapon = load(path).instantiate()
		var display_name: String = weapon.na if weapon.na != "" else weapon_key
		weapon.free()
		return display_name
	return weapon_key

func _character_display_name(key: String) -> String:
	match key:
		"aho": return "阿猴"
		"carmor": return "卡莫"
		"alew": return "阿女"
		_: return key

func _weapon_icon(weapon_key: String) -> Texture2D:
	var path := "res://scene/weapon/%s.tscn" % weapon_key
	if not ResourceLoader.exists(path):
		return _achievement_icon()
	var weapon: Node = load(path).instantiate()
	var tex: Texture2D = weapon.texture if weapon is BaseWeapon else null
	weapon.free()
	return tex if tex else _achievement_icon()

func _character_icon(character_key: String) -> Texture2D:
	if character_key not in GameInfo.CHARACTER_SCENES:
		return _achievement_icon()
	var player: BasePlayer = load(GameInfo.CHARACTER_SCENES[character_key]).instantiate()
	var tex: Texture2D = player.sprite.texture if player.sprite else null
	player.free()
	return tex if tex else _achievement_icon()

func _achievement_icon() -> Texture2D:
	var atlas := AtlasTexture.new()
	atlas.atlas = AssetAtlas
	atlas.region = Rect2(200, 700, 100, 100)
	return atlas
