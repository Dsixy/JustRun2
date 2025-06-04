extends Sprite2D

const na := "升级套装"
const description := "拖拽到武器上以提升武器等级"
# To process the drag event
func process_slot(cur: Node, drag: Node):
	if is_instance_of(cur, BaseWeapon):
		if cur.level < 4:
			cur.upgrade()
			return [cur, null]
		
	return [drag, cur]
