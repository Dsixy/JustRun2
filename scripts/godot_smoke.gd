extends SceneTree

# Headless parse check only — does NOT run main menu or gameplay.

const SCRIPT_PATHS: Array[String] = [
	"res://script/viewport_constants.gd",
	"res://script/player_skill_properties.gd",
	"res://script/weapon_ids.gd",
	"res://script/scene/loot_spawner.gd",
	"res://script/scene/wave_director.gd",
	"res://script/Events.gd",
	"res://script/damage_types.gd",
	"res://script/damage_info.gd",
	"res://script/buff/buff_element_reactions.gd",
	"res://script/buff/buff_ids.gd",
	"res://script/buff/burning_buff.gd",
	"res://script/buff/poison_buff.gd",
	"res://script/buff/lightning_buff.gd",
	"res://script/buff/weaken_buff.gd",
	"res://script/effect/lightning_bolt.gd",
	"res://script/utils.gd",
	"res://script/game_info.gd",
	"res://script/run_stats.gd",
	"res://script/unlock_toast.gd",
	"res://script/weapon/base_weapon.gd",
	"res://script/scene.gd",
	"res://script/UI/weapon_handbook_catalog.gd",
	"res://script/UI/handbook_text.gd",
	"res://script/UI/book_slot.gd",
	"res://script/UI/illustrated_handbook.gd",
	"res://script/UI/pause_menu.gd",
]

func _init() -> void:
	call_deferred("_finish")

func _finish() -> void:
	for path in SCRIPT_PATHS:
		if load(path) == null:
			push_error("godot_smoke: cannot load %s" % path)
			quit(1)
			return
	quit(0)
