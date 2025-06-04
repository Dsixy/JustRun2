extends TextureRect

const modulate_dir = [Color8(255, 255, 255), Color8(100, 255, 100,),
						Color8(100, 100, 255), Color8(200, 100, 255),
						Color8(255, 100, 100)]
@onready var itemTexture = $ContentTexture
var current_item: Node = null
var type: String
	
func _ready():
	pass
	
func _can_drop_data(position, data):
	return data.has("type") and data["type"] == "item" and is_avaiable(data["item"])

func _get_drag_data(position):
	if current_item:
		var drag_preview = TextureRect.new()
		drag_preview.texture = itemTexture.texture
		drag_preview.pivot_offset = Vector2(50, 50)
		set_drag_preview(drag_preview)

		return {
			"type": "item",
			"item": current_item,
			"from_slot": self
		}
	else:
		return null

func _drop_data(position, data):
	var cur = current_item
	var drag = data["item"]
	var res
	clear_item()
	
	if data["item"]:
		res = data["item"].process_slot(cur, drag)
	else:
		res = [drag, cur]
		
	cur = res[0]
	drag = res[1]
	add_item(cur)
	data["from_slot"].clear_item()
	data["from_slot"].add_item(drag)
	
func add_item(item: Sprite2D):
	self.current_item = item
	if current_item:
		itemTexture.texture = item.texture
	else:
		itemTexture.texture = null
	update_modulate()
	
func clear_item():
	self.current_item = null
	itemTexture.texture = null
	
func update_modulate():
	if is_instance_of(current_item, BaseWeapon):
		self_modulate = self.modulate_dir[self.current_item.level]
	else:
		self_modulate = self.modulate_dir[0]
		
func set_type(type: String):
	self.type = type
	
func is_avaiable(item: Node):
	if self.type == "bag":
		return true
	elif self.type == "weapon arm":
		return is_instance_of(item, BaseWeapon)
	else:
		return false
