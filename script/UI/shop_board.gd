extends Control

var player: BasePlayer
@onready var slotList = [$ShopSlot, $ShopSlot2, $ShopSlot3, $ShopSlot4]
@onready var rainbowSweetScene = preload("res://scene/item/rainbow_sweet.tscn")
@onready var upgradeToolScene = preload("res://scene/item/upgrade_tool.tscn")
@onready var mirrorScene = preload("res://scene/item/mirror.tscn")
@onready var freshBotton = $RefreshBotton
var currentFreshTime: int = 0
signal close

func _ready():
	pass # Replace with function body.

func init(player: BasePlayer, cfg_dict: Dictionary):
	self.player = player
	for i in range(4):
		slotList[i].player = self.player
	refresh()
	
func refresh():
	set_slot_item(0, [1])
	for i in range(1, 4):
		set_slot_item(i)

func set_slot_item(idx: int, weight: Array = [0.7, 0.14, 0.14, 0.02]):
	var i = Utils.random_weighted(weight)
	var content
	match i:
		0: 
			var j = randi() % len(GameInfo.weaponAllPath)
			content = load(GameInfo.weaponAllPath[j]).instantiate()
		1:
			content = rainbowSweetScene.instantiate()
		2:
			content = mirrorScene.instantiate()
		3:
			content = upgradeToolScene.instantiate()
		
	slotList[idx].set_content(content, Utils.set_price(player.level) * player.discountRate)

func close_board():
	queue_free()

func _on_refresh_botton_pressed():
	if currentFreshTime < player.refreshTime:
		refresh()
		currentFreshTime += 1
		if currentFreshTime == player.refreshTime:
			freshBotton.modulate = Color8(100, 100, 100)

func _on_return_button_pressed():
	emit_signal("close")
