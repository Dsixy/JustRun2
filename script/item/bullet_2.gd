extends HitArea

@onready var hitbox = $Hitbox
var direction: Vector2 = Vector2.ZERO
var speed: int = 0
var pierce: bool = false
var max_path: int = 3000

func _process(delta):
	position += direction * speed * delta
	max_path -= speed * delta
	if max_path < 0:
		delete()
	
func init(pos: Vector2, direction: Vector2, speed: int, damage: DamageInfo,
	 max_path: int, pierce: bool):
	self.global_position = pos
	self.direction = direction.normalized()
	self.rotation = direction.angle()
	self.speed = speed
	self.damage = damage
	self.max_path = max_path
	self.pierce = (pierce and damage.isCrit)
	
func delete():
	queue_free()

func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		if not pierce:
			delete()
		area.get_parent().be_hit(damage)
