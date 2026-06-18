extends Node

## 单局战斗统计 + 解锁条件检测（patch Phase A2/A3/A5）

const DOT_WEAPON_KEYS = ["poison_vial", "perfume_bottle", "hail_brace"]

var active: bool = false
var run_character_key: String = ""
var run_character_path: String = ""
var kills: int = 0
var money_earned: float = 0.0
var money_spent: float = 0.0
var plants_picked: int = 0
var blue_mountain_leaves: int = 0
var hp_lost: float = 0.0
var waves_cleared: int = 0
var victory: bool = false
var player_level: int = 0

var _unlocked_this_run: Array[String] = []

func begin_run(character_scene_path: String) -> void:
	active = true
	_unlocked_this_run.clear()
	run_character_path = character_scene_path
	run_character_key = GameInfo.get_character_key_from_path(character_scene_path)
	kills = 0
	money_earned = 0.0
	money_spent = 0.0
	plants_picked = 0
	blue_mountain_leaves = 0
	hp_lost = 0.0
	waves_cleared = 0
	victory = false
	player_level = 0

func end_run(won: bool, final_level: int, weapon_list: Array = []) -> void:
	if not active:
		return
	victory = won
	player_level = final_level
	active = false
	_apply_meta_progress(won)
	_apply_unlocks(weapon_list)

func notify_unlock(weapon_key: String) -> void:
	if weapon_key not in _unlocked_this_run:
		_unlocked_this_run.append(weapon_key)

func record_kill() -> void:
	if not active:
		return
	kills += 1

func record_money_earned(amount: float) -> void:
	if not active or amount <= 0.0:
		return
	money_earned += amount

func record_money_spent(amount: float) -> void:
	if not active or amount <= 0.0:
		return
	money_spent += amount

func record_plant_picked() -> void:
	if not active:
		return
	plants_picked += 1

func record_blue_mountain_leaf() -> void:
	if not active:
		return
	blue_mountain_leaves += 1

func record_hp_lost(amount: float) -> void:
	if not active or amount <= 0.0:
		return
	hp_lost += amount

func record_wave_cleared(wave_index: int) -> void:
	if not active:
		return
	waves_cleared = maxi(waves_cleared, wave_index)

func get_summary_text() -> String:
	var result := "通关！" if victory else "你失败了"
	var lines: PackedStringArray = [
		result,
		"角色：%s" % _character_display_name(run_character_key),
		"等级：%d" % player_level,
		"击杀：%d" % kills,
		"获得金币：%.0f" % money_earned,
		"消费金币：%.0f" % money_spent,
		"拾取植物：%d" % plants_picked,
		"完成波次：%d" % waves_cleared,
	]
	var unlock_lines := _new_unlock_lines()
	if not unlock_lines.is_empty():
		lines.append("")
		lines.append("本局解锁：")
		for line in unlock_lines:
			lines.append("· " + line)
	return "\n".join(lines)

func _character_display_name(key: String) -> String:
	match key:
		"aho": return "阿猴"
		"carmor": return "卡莫"
		"alew": return "阿女"
		_: return key if key != "" else "未知"

func _apply_meta_progress(won: bool) -> void:
	if plants_picked > 0:
		GameInfo.add_meta_stat("plants_picked_total", plants_picked)
	if blue_mountain_leaves > 0:
		GameInfo.add_meta_stat("blue_mountain_leaf_total", blue_mountain_leaves)
	if kills > 0:
		GameInfo.add_meta_stat("kills_total", kills)
	if not won:
		GameInfo.add_meta_stat("run_failures_total", 1)

func _apply_unlocks(weapon_list: Array) -> void:
	if money_spent >= 4000.0:
		_try_unlock_weapon("delivery_guy")
	if money_earned >= 6000.0:
		_try_unlock_weapon("coin_gun")
	if victory and _arm_loadout_all_dot(weapon_list):
		_try_unlock_weapon("spider_silk")
	if victory and _has_duplicate_weapons(weapon_list):
		_try_unlock_weapon("replicator")
	if GameInfo.get_meta_stat("plants_picked_total") >= 100:
		_try_unlock_weapon("perfume_bottle")
	if GameInfo.get_meta_stat("blue_mountain_leaf_total") >= 50:
		_try_unlock_weapon("leaf")
	if run_character_key == "carmor" and kills >= 1000:
		_try_unlock_weapon("stellar_wrath")
	if hp_lost >= 1000.0:
		_try_unlock_weapon("spirit_conch")
	if GameInfo.get_meta_stat("kills_total") >= 5000:
		_try_unlock_weapon("wrench")
	if GameInfo.get_meta_stat("run_failures_total") >= 20:
		_try_unlock_weapon("tear")

func _try_unlock_weapon(weapon_key: String) -> void:
	if GameInfo.config.get_value("WeaponUnlock", weapon_key, false):
		return
	GameInfo.unlock_weapon(weapon_key)
	notify_unlock(weapon_key)

func _new_unlock_lines() -> Array[String]:
	var lines: Array[String] = []
	for key in _unlocked_this_run:
		lines.append(_weapon_display_name(key))
	return lines

func _weapon_display_name(key: String) -> String:
	match key:
		"delivery_guy": return "外卖员"
		"coin_gun": return "金币枪"
		"spider_silk": return "蛛丝"
		"perfume_bottle": return "香水瓶"
		"stellar_wrath": return "群星之怒"
		"hail_brace": return "冰霜手镯"
		"leaf": return "叶子"
		"replicator": return "复制器"
		"spirit_conch": return "唤灵海螺"
		"wrench": return "扳手"
		"tear": return "泪水"
		"comic_book": return "漫画书"
		"cat_trick": return "猫之计谋"
		"lightwheel": return "极速光轮"
		"poison_vial": return "毒药瓶"
		_: return key

static func weapon_key_from(weapon: BaseWeapon) -> String:
	if weapon == null:
		return ""
	var script_path: String = weapon.get_script().resource_path
	return script_path.get_file().get_basename()

static func weapon_has_dot_effect(weapon: BaseWeapon) -> bool:
	if weapon == null:
		return true
	var key := weapon_key_from(weapon)
	if key in DOT_WEAPON_KEYS:
		return true
	if key == "rocket_launcher" and weapon.get("burningBuff"):
		return bool(weapon.burningBuff)
	return false

static func _arm_loadout_all_dot(weapon_list: Array) -> bool:
	var has_weapon := false
	for weapon in weapon_list:
		if weapon:
			has_weapon = true
			if not weapon_has_dot_effect(weapon):
				return false
	return has_weapon

static func _has_duplicate_weapons(weapon_list: Array) -> bool:
	var seen: Dictionary = {}
	for weapon in weapon_list:
		if weapon == null:
			continue
		var wid: int = weapon.id
		if seen.has(wid):
			return true
		seen[wid] = true
	return false
