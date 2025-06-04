extends HitArea

var maxPath: int = 3000
var path: float = 0.0
var speed: int = 400

func _process(delta):
	position += speed * delta * Vector2.RIGHT
	path += speed * delta
	if path >= maxPath:
		delete()
	
func init(pos:Vector2, speed: int, damage: DamageInfo):
	self.global_position = pos
	self.damage = damage
	self.speed = speed
	self.scale *= (randf() * 0.4 + 1)
	
func delete():
	queue_free()
