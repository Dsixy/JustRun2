extends Node

var mainscene: Node = null
var current_cursor_item = null
var player: String = ""

var weaponAllPath = []

var config = ConfigFile.new()

func _ready():
	config.load("user://config.cfg")
	
	config.set_value("WeaponUnlock", "pistol", true)
	config.set_value("WeaponUnlock", "poker", false)
	config.set_value("WeaponUnlock", "shotgun", true)
	config.set_value("WeaponUnlock", "sniping_riffe", true)
	config.set_value("WeaponUnlock", "stellar_wrath", false)
	config.set_value("WeaponUnlock", "thought_bubble", false)
	config.set_value("WeaponUnlock", "hail_brace", false)
	config.set_value("WeaponUnlock", "laser_sword", false)
	config.set_value("WeaponUnlock", "song_of_soul", false)
	config.set_value("WeaponUnlock", "poison_vial", false)
	config.set_value("WeaponUnlock", "laser_gun", false)
	config.set_value("WeaponUnlock", "perfume_bottle", false)
	config.set_value("WeaponUnlock", "spider_silk", false)
	config.set_value("WeaponUnlock", "mest", false)
	config.set_value("WeaponUnlock", "delivery_guy", false)
	config.set_value("WeaponUnlock", "falling_blossom", false)
	config.set_value("WeaponUnlock", "comic_book", false)
	config.set_value("WeaponUnlock", "coin_gun", false)
	config.set_value("WeaponUnlock", "cat_trick", false)
	config.set_value("WeaponUnlock", "wrench", false)
	#
	#config.save("user://config.cfg")
	
func refresh():
	for key in config.get_section_keys("WeaponUnlock"):
		if config.get_value("WeaponUnlock", key):
			weaponAllPath.append("res://scene/weapon/" + key + ".tscn")
			
func save():
	config.save("user://config.cfg")


