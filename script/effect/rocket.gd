extends HitArea

@onready var sprite = $Sprite2D
@export var explodeScene: PackedScene
var direction: Vector2 = Vector2.ZERO
var speed: int = 0
var target: Vector2
var burning: bool
var explodeRadius: int = 100

func _process(delta):
	position += direction * speed * delta
	if (target - global_position).length_squared() < 100:
		explode()
	self.rotation = direction.angle() + PI / 4
	self.direction = (self.direction * 0.9 + (target - global_position).normalized() * 0.1).normalized()

func init(pos: Vector2, direction: Vector2, target: Vector2, speed: int, damage: DamageInfo,\
		huge: bool, burning: bool):		
	self.global_position = pos
	self.direction = direction.normalized()
	self.target = target
	self.speed = speed
	self.damage = damage
	self.burning = burning
	if huge:
		self.sprite.frame = 0
		self.scale *= 2
		self.speed /= 2
		self.explodeRadius *= 2
	
func delete():
	queue_free()

func explode():
	var e = explodeScene.instantiate()
	GameInfo.mainscene.effectNode.add_child(e)
	e.init(global_position, damage, 0.3, explodeRadius, burning)
	queue_free()

func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		area.get_parent().be_hit(damage.copy())
		explode()
