extends PickableItem

const n = "WineRose"
func on_picked_up(sub: BasePlayer):
	sub.HP = min(sub.maxHP, sub.HP + 99)
