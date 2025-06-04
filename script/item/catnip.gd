extends PickableItem

const n = "Catnip"
func on_picked_up(sub: BasePlayer):
	sub.refreshTime += 1
