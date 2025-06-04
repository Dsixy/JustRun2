extends HitArea

var direction: Vector2 = Vector2.ZERO
var speed: int = 0
var max_path: int = 3000

func _process(delta):
	position += direction * speed * delta
	max_path -= speed * delta
	if max_path < 0:
		delete()
	
func init(pos: Vector2, direction: Vector2, speed: int, damage: DamageInfo):		
	self.global_position = pos
	self.direction = direction.normalized()
	self.rotation = self.direction.angle() + PI / 2
	self.speed = speed
	self.damage = damage
	
func delete():
	queue_free()

func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		area.get_parent().be_hit(damage.copy())
		delete()
