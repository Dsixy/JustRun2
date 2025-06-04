extends PickableItem

const n = "BlueMountainLeaf"
func on_picked_up(sub: BasePlayer):
	sub.upgrade()
