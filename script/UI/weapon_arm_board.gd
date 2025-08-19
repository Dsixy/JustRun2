extends Control

@onready var panel = $Panel
@onready var slotScene = preload("res://scene/UI/ui_slot.tscn")

var slotList = []
var weaponArm: BaseWeaponArm

func init(player: BasePlayer, cfg_dict: Dictionary = {}):
	weaponArm = player.weaponArm
	panel.texture = weaponArm.weaponArmBoardTexture.duplicate()
	load_slot(player.weaponArm)
	
func load_slot(weaponArm: BaseWeaponArm):
	for i in range(len(weaponArm.slotPos)):
		var slot = slotScene.instantiate()
		slotList.append(slot)
		panel.add_child(slot)
		slot.set_type("weapon arm")
		slot.position = weaponArm.slotPos[i]
		slot.scale *= weaponArm.slotScale
		slot.add_item(weaponArm.weaponList[i])
		
func close_board():
	var weaponList = []
	for slot in slotList:
		if slot.current_item:
			weaponList.append(slot.current_item)
		else:
			weaponList.append(null)
	weaponArm.weaponList = weaponList
	weaponArm.update_weapons()
	queue_free()
