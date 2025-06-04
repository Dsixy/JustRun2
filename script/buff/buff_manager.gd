extends Node

var activeBuff = {}

func _process(delta):
	for buffID in activeBuff:
		activeBuff[buffID].process(delta)
		
func add_buff(buff: Buff):
	if buff.ID in activeBuff:
		activeBuff[buff.ID].stack(buff)
	else:
		add_child(buff)
		buff.connect("on_expired", _on_buff_expired)
		activeBuff[buff.ID] = buff
		buff.apply(get_parent())

func modify_damage(damage: DamageInfo):
	for buffID in activeBuff:
		damage = activeBuff[buffID].modify_damage(damage)
	return damage
	
func _on_buff_expired(buff: Buff):
	activeBuff.erase(buff.ID)
	buff.call_deferred("queue_free")
