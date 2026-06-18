extends PickableItem

const n = "BlueMountainLeaf"
func on_picked_up(sub: BasePlayer):
	RunStats.record_blue_mountain_leaf()
	sub.upgrade()
