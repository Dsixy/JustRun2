extends TextureRect

var content
var price: int = 0
var player: BasePlayer
var be_sold: bool = false

@onready var priceLabel = $Price/Label
@onready var itemTexture = $ItemTexture

func _ready():
	pass # Replace with function body.

func init(player: BasePlayer):
	self.player = player
	
func set_content(content, price: int):
	self.content = content
	self.price = price
	priceLabel.text = str(self.price)
	itemTexture.texture = content.texture
	
	self.itemTexture.modulate = Color8(255, 255, 255)
	be_sold = false

func _be_sold():
	be_sold = true
	self.itemTexture.modulate = Color8(0, 0, 0, 50)
	
func can_player_buy():
	if player.money < self.price or be_sold:
		return -1
		
	return player.get_empty_inventory_idx()
	
func _on_button_pressed():
	var i = can_player_buy()
	if i >= 0:
		player.spend_money(price)
		_be_sold()
		var item = self.content.duplicate()
		player.inventory[i] = item
		if item is BaseWeapon:
			var weapon_key := RunStats.weapon_key_from(item)
			if weapon_key == "cat_trick" and not GameInfo.is_weapon_unlocked("cat_trick"):
				GameInfo.unlock_weapon("cat_trick")
				RunStats.notify_unlock("cat_trick")
		if player.inventory[i].name == "RainbowSweet":
			player.inventory[i] = null
			player.abilityPoint += 1
