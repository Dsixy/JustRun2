extends Sprite2D

const na := "镜子"
const description := "拖拽到武器上以复制武器的一级版本"
# To process the drag event
func process_slot(cur: Node, drag: Node):
	if is_instance_of(cur, BaseWeapon):
		var new_item = cur.duplicate()
		return [cur, new_item]
	return [drag, cur]
