extends Node

var mainscene: Node = null
var current_cursor_item = null
var player: String = ""
var cheat: bool = false

var weaponAllPath = []

var config = ConfigFile.new()

func _ready():
	config.load("user://config.cfg")
	
	config.set_value("WeaponUnlock", "pistol", true)
	config.set_value("WeaponUnlock", "poker", true)
	config.set_value("WeaponUnlock", "shotgun", true)
	config.set_value("WeaponUnlock", "sniping_riffe", true)
	config.set_value("WeaponUnlock", "stellar_wrath", true)
	config.set_value("WeaponUnlock", "thought_bubble", true)
	config.set_value("WeaponUnlock", "hail_brace", true)
	config.set_value("WeaponUnlock", "laser_sword", true)
	config.set_value("WeaponUnlock", "song_of_soul", true)
	config.set_value("WeaponUnlock", "poison_vial", true)
	config.set_value("WeaponUnlock", "laser_gun", true)
	config.set_value("WeaponUnlock", "perfume_bottle", true)
	config.set_value("WeaponUnlock", "spider_silk", true)
	config.set_value("WeaponUnlock", "mest", true)
	config.set_value("WeaponUnlock", "delivery_guy", true)
	config.set_value("WeaponUnlock", "falling_blossom", true)
	config.set_value("WeaponUnlock", "comic_book", true)
	config.set_value("WeaponUnlock", "coin_gun", true)
	config.set_value("WeaponUnlock", "cat_trick", true)
	config.set_value("WeaponUnlock", "wrench", true)
	config.set_value("WeaponUnlock", "rocket_launcher", true)
	config.set_value("WeaponUnlock", "option", true)
	config.set_value("WeaponUnlock", "lightwheel", true)
	config.set_value("WeaponUnlock", "leaf", true)
	config.set_value("WeaponUnlock", "spirit_conch", true)
	config.set_value("WeaponUnlock", "replicator", true)
	#
	#config.save("user://config.cfg")
	
func refresh():
	for key in config.get_section_keys("WeaponUnlock"):
		if config.get_value("WeaponUnlock", key):
			weaponAllPath.append("res://scene/weapon/" + key + ".tscn")
			
func save():
	config.save("user://config.cfg")


