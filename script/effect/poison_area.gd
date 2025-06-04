extends HitArea

@onready var area = $Area2D
@onready var poisonBuffScene = preload("res://scene/buff/poison_buff.tscn")
const tickInterval:= 1.0
var elapsedTime := 0.9

func _process(delta):
	elapsedTime += delta
	if elapsedTime >= tickInterval:
		elapsedTime -= tickInterval
		on_tick()
	
func init(pos: Vector2, range: float, damage: DamageInfo):
	self.global_position = pos
	self.damage = damage
	self.scale *= range
	on_tick()
	
func on_tick():
	var areas = area.get_overlapping_areas()
	for a in areas:
		if a.is_in_group("enemy"):
			var enemy = a.get_parent()
			enemy.be_hit(damage.copy())
			
			var buff = poisonBuffScene.instantiate()
			buff.set_up(GameInfo.mainscene.player)
			enemy.buffManager.add_buff(buff)

func _on_timer_timeout():
	queue_free()
