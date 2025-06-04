extends Sprite2D

@onready var area = $Area2D
var damagePercent: float
var keepBuff: bool
func init(pos: Vector2, range: float, keepBuff: bool, damagePercent: float):
	self.global_position = pos
	self.keepBuff = keepBuff
	self.damagePercent = damagePercent
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * range * 4, 0.4)
	tween.tween_callback(activate)
	
func activate():
	var areas = area.get_overlapping_areas()
	var buff
	var to_remove = []
	for a in areas:
		if a.is_in_group("enemy"):
			var e: BaseEnemy = a.get_parent()
			for buffID in e.buffManager.activeBuff:
				buff = e.buffManager.activeBuff[buffID]
				if is_instance_of(buff, DotBuff):
					var damage = buff.damage.copy()
					damage.baseAmount = (buff.duration - buff.elapsed) /\
						 buff.tickInterval * buff.damage.baseAmount * damagePercent
					if not keepBuff:
						to_remove.append(buff)
					e.be_hit(damage)
	for b in to_remove:
		b.expire()
		
	await get_tree().create_timer(0.3).timeout
	queue_free()

