extends Node2D

const shieldBuff = preload("res://scene/buff/cat_shield_buff.tscn")

func init(player: BasePlayer, maxStack: int):
	var kill = false
	if player.buffManager.activeBuff.has(10):
		kill = true
	var buff: Buff = shieldBuff.instantiate()
	buff.set_up(self)
	buff.maxStack = maxStack
	player.buffManager.add_buff(buff)
	if kill:
		delete(null)
		return
	buff.connect("on_expired", delete)
	
func delete(_k):
	queue_free()
