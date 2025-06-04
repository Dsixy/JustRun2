extends PickableItem

const n = "Hyacinth"

func on_picked_up(sub: BasePlayer):
	var buff = preload("res://scene/buff/haste_buff.tscn").instantiate()
	buff.set_up(sub)
	sub.buffManager.add_buff(buff)
