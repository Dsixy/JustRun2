extends TextureRect

func _can_drop_data(position, data):
	return data.has("type") and data["type"] == "item"

func _drop_data(position, data):
	data["from_slot"].clear_item()
	
