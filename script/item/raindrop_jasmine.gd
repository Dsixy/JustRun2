extends PickableItem

const n = "RaindropJasmine"
func on_picked_up(sub: BasePlayer):
	var buff = preload("res://scene/buff/invince_buff.tscn").instantiate()
	buff.set_up(sub)
	sub.buffManager.add_buff(buff)
