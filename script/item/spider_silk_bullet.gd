extends HitArea

@export var SpiderWebScene: PackedScene
var direction: Vector2 = Vector2.ZERO
var speed: int = 0
var max_path: int = 3000
var range: float
var keepBuff: bool
var damagePercent: float

func _process(delta):
	position += direction * speed * delta
	max_path -= speed * delta
	if max_path < 0:
		delete()
	
func init(pos: Vector2, direction: Vector2, speed: int, damage: DamageInfo,\
	keepBuff: bool, range: float, damagePercent: float):		
	self.global_position = pos
	self.direction = direction.normalized()
	self.rotation = self.direction.angle() + PI / 2
	self.speed = speed
	self.damage = damage
	self.range = range
	self.damagePercent = damagePercent
	self.keepBuff = keepBuff
	
func delete():
	queue_free()

func explode():
	var s = SpiderWebScene.instantiate()
	GameInfo.mainscene.add_child(s)
	s.init(global_position, range, keepBuff, self.damagePercent)
	delete()

func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		area.get_parent().be_hit(damage.copy())
		explode()
