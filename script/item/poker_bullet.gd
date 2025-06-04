extends HitArea

@export var explodeScene: PackedScene
var direction: Vector2 = Vector2.ZERO
var speed: int = 0
var idx: int = 0
var pierce: int = 0
var max_path: int = 3000
var canExplode: bool = false
var radius: int = 0

func _process(delta):
	position += direction * speed * delta
	max_path -= speed * delta
	if max_path < 0:
		delete()
	
func init(idx: int, pos: Vector2, direction: Vector2, speed: int, damage: DamageInfo, radius: int):
	self.idx = idx
	self.frame = self.idx
	if self.frame == 3:
		canExplode = true
		scale = Vector2(1, 1)
		self.radius = radius
		
	self.global_position = pos
	self.direction = direction.normalized()
	self.rotation = self.direction.angle() + PI / 2
	self.speed = speed
	self.damage = damage
	
func delete():
	queue_free()

func explode():
	var e = explodeScene.instantiate()
	GameInfo.mainscene.add_child(e)
	e.init(global_position, damage, 0.3, radius)
	delete()

func _on_hitbox_area_entered(area):
	if area.is_in_group("enemy"):
		if canExplode:
			explode()
		elif pierce <= 0:
			delete()
		pierce -= 1
		area.get_parent().be_hit(damage)
