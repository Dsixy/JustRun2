extends Sprite2D

const na := "彩虹糖"
const description := "购买后提升玩家一点能力点"
# To process the drag event
func process_slot(cur: Node, drag: Node):
	return [drag, cur]
