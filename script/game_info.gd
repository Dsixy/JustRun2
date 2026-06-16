extends Node

var mainscene: Node = null
var current_cursor_item = null
var player: String = ""
var cheat: bool = false

var weaponAllPath = []

var config = ConfigFile.new()

# 新档默认解锁（其余靠事件 / 天赋解锁）
const DEFAULT_WEAPON_UNLOCKS = ["pistol"]

# 选角：patch 初始仅阿猴；卡莫 / 阿女剧情后解锁
const CHARACTER_SCENES = {
	"aho": "res://scene/player/aho.tscn",
	"carmor": "res://scene/player/carmor.tscn",
	"alew": "res://scene/player/alew.tscn",
}
const CHARACTER_ORDER = ["aho", "carmor", "alew"]
const DEFAULT_CHARACTER_UNLOCKS = ["aho"]

# 未设计完成，暂不出现在商店 / 作弊武器栏
const DISABLED_WEAPONS = ["maiden_touch", "moon_phase_dial", "option"]

const DEFAULT_EVENTS = [
	"first_to_wave_3",
	"first_to_wave_6",
	"first_to_level_10",
	"seen_popocat_hint",
]

func _ready():
	config.load("user://config.cfg")
	_ensure_defaults()

func _ensure_defaults() -> void:
	var dirty := false
	for weapon in DEFAULT_WEAPON_UNLOCKS:
		if not config.has_section_key("WeaponUnlock", weapon):
			config.set_value("WeaponUnlock", weapon, true)
			dirty = true
		if not config.has_section_key("WeaponHandbook", weapon):
			config.set_value("WeaponHandbook", weapon, 0)
			dirty = true
	for event in DEFAULT_EVENTS:
		if not config.has_section_key("Event", event):
			config.set_value("Event", event, false)
			dirty = true
	for character_key in DEFAULT_CHARACTER_UNLOCKS:
		if not config.has_section_key("CharacterUnlock", character_key):
			config.set_value("CharacterUnlock", character_key, true)
			dirty = true
	if dirty:
		save()
	_migrate_legacy_events()
	_sync_character_unlocks_from_events()
	_strip_disabled_weapon_unlocks()

func _migrate_legacy_events() -> void:
	var dirty := false
	if config.get_value("Event", "first_to_wave_10", false):
		config.set_value("Event", "first_to_wave_3", true)
		dirty = true
	if config.get_value("Event", "first_to_wave_20", false):
		config.set_value("Event", "first_to_wave_6", true)
		dirty = true
	if config.get_value("Event", "first_to_wave_7", false):
		config.set_value("Event", "first_to_wave_6", true)
		dirty = true
	if dirty:
		save()

func _sync_character_unlocks_from_events() -> void:
	var dirty := false
	if get_event("first_to_wave_3"):
		if not is_character_unlocked("carmor"):
			config.set_value("CharacterUnlock", "carmor", true)
			dirty = true
	if get_event("first_to_wave_6"):
		if not is_character_unlocked("alew"):
			config.set_value("CharacterUnlock", "alew", true)
			dirty = true
	if dirty:
		save()

func _strip_disabled_weapon_unlocks() -> void:
	var dirty := false
	for weapon in DISABLED_WEAPONS:
		if config.get_value("WeaponUnlock", weapon, false):
			config.set_value("WeaponUnlock", weapon, false)
			dirty = true
	if dirty:
		save()

func is_weapon_enabled(weapon_key: String) -> bool:
	return weapon_key not in DISABLED_WEAPONS

func refresh():
	weaponAllPath.clear()
	if not config.has_section("WeaponUnlock"):
		return
	for key in config.get_section_keys("WeaponUnlock"):
		if config.get_value("WeaponUnlock", key) and is_weapon_enabled(key):
			weaponAllPath.append("res://scene/weapon/" + key + ".tscn")

func save():
	config.save("user://config.cfg")

func unlock_weapon(weapon_key: String, silent: bool = false) -> bool:
	if not is_weapon_enabled(weapon_key):
		return false
	if config.get_value("WeaponUnlock", weapon_key, false):
		return false
	config.set_value("WeaponUnlock", weapon_key, true)
	if get_weapon_handbook_max_level(weapon_key) < 0:
		config.set_value("WeaponHandbook", weapon_key, 0)
	save()
	if not silent:
		UnlockToast.enqueue_weapon(weapon_key)
	return true

func is_character_unlocked(character_key: String) -> bool:
	return config.get_value("CharacterUnlock", character_key, false)

func unlock_character(character_key: String, silent: bool = false) -> bool:
	if character_key not in CHARACTER_SCENES:
		return false
	if is_character_unlocked(character_key):
		return false
	config.set_value("CharacterUnlock", character_key, true)
	save()
	if not silent:
		UnlockToast.enqueue_character(character_key)
	return true

func get_unlocked_character_scene_paths() -> Array[String]:
	var paths: Array[String] = []
	for character_key in CHARACTER_ORDER:
		if is_character_unlocked(character_key):
			paths.append(CHARACTER_SCENES[character_key])
	return paths

func get_all_character_scene_paths() -> Array[String]:
	var paths: Array[String] = []
	for character_key in CHARACTER_ORDER:
		paths.append(CHARACTER_SCENES[character_key])
	return paths

## 选角列表：作弊时全部角色（不写 config）；否则读存档解锁
func get_selectable_character_scene_paths() -> Array[String]:
	if cheat:
		return get_all_character_scene_paths()
	return get_unlocked_character_scene_paths()

func get_character_key_from_path(scene_path: String) -> String:
	for character_key in CHARACTER_ORDER:
		if CHARACTER_SCENES[character_key] == scene_path:
			return character_key
	return scene_path.get_file().get_basename()

func add_meta_stat(key: String, delta) -> void:
	var current = config.get_value("Meta", key, 0)
	if typeof(current) != typeof(delta):
		current = 0
	config.set_value("Meta", key, current + delta)
	save()

func get_meta_stat(key: String, default_value = 0):
	return config.get_value("Meta", key, default_value)

func set_event(event_key: String, value: bool = true) -> void:
	var was_set := get_event(event_key)
	config.set_value("Event", event_key, value)
	save()
	if value and not was_set:
		_notify_event_achievement(event_key)

func _notify_event_achievement(event_key: String) -> void:
	match event_key:
		"first_to_wave_3":
			UnlockToast.enqueue_achievement("剧情成就", "抵达第 3 波 · 初遇卡莫")
		"first_to_wave_6":
			UnlockToast.enqueue_achievement("剧情成就", "抵达第 6 波 · 初遇阿女")

func is_weapon_unlocked(weapon_key: String) -> bool:
	return is_weapon_enabled(weapon_key) and config.get_value("WeaponUnlock", weapon_key, false)

func get_weapon_handbook_max_level(weapon_key: String) -> int:
	return int(config.get_value("WeaponHandbook", weapon_key, -1))

func record_weapon_handbook_level(weapon_key: String, level: int) -> void:
	if not is_weapon_unlocked(weapon_key):
		return
	var current := get_weapon_handbook_max_level(weapon_key)
	if current < 0:
		current = 0
	if level > current:
		config.set_value("WeaponHandbook", weapon_key, level)
		save()

func sync_weapon_handbook_defaults() -> void:
	var dirty := false
	if not config.has_section("WeaponUnlock"):
		return
	for weapon_key in config.get_section_keys("WeaponUnlock"):
		if not config.get_value("WeaponUnlock", weapon_key, false):
			continue
		if not is_weapon_enabled(weapon_key):
			continue
		if get_weapon_handbook_max_level(weapon_key) < 0:
			config.set_value("WeaponHandbook", weapon_key, 0)
			dirty = true
	if dirty:
		save()

func get_event(event_key: String) -> bool:
	return config.get_value("Event", event_key, false)

func get_all_weapon_scene_paths() -> Array[String]:
	var paths: Array[String] = []
	var dir := DirAccess.open("res://scene/weapon/")
	if dir == null:
		return paths
	for file_name in dir.get_files():
		if not file_name.ends_with(".tscn") or file_name == "base_weapon.tscn":
			continue
		var weapon_key = file_name.get_basename()
		if is_weapon_enabled(weapon_key):
			paths.append("res://scene/weapon/" + file_name)
	paths.sort()
	return paths
