extends Control

var player: BasePlayer
var itemList = []
var slotList

func _ready():
	pass # Replace with function body.

func init(player: BasePlayer):
	self.player = player
	self.slotList = $Panel/HBoxContainer.get_children()
	
	for i in range(len(player.inventory)):
		itemList.append(player.inventory[i])
		self.slotList[i].set_type("bag")
		self.slotList[i].add_item(player.inventory[i])
		
func close_board():
	for i in range(len(self.slotList)):
		player.inventory[i] = self.slotList[i].current_item
		
	queue_free()
