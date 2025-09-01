extends HitArea

@onready var area = $Area2D
var direction: Vector2 = Vector2.ZERO
var speed: int = 0
var max_path: int = 3000
var time: int = 1
var explodeNum: int = 4
var tearBallScene: PackedScene
var canGenerate: bool = false
var maxStack: int = 4

func _process(delta):
	position += direction * speed * delta
	max_path -= speed * delta
	if max_path < 0:
		generate()
		delete()
	
func init(pos: Vector2, direction: Vector2, speed: int, damage: DamageInfo,
	max_path: int, explodeNum: int, tearBallScene: PackedScene, can: bool=false,
	maxStack: int=false):
	self.global_position = pos
	self.direction = direction.normalized()
	self.rotation = direction.angle() - PI / 2
	self.speed = speed
	self.damage = damage
	self.max_path = max_path
	
	self.explodeNum = explodeNum
	self.tearBallScene = tearBallScene
	self.canGenerate = can
	self.maxStack = maxStack

func delete():
	queue_free()
	
func generate():
	var tearBall = tearBallScene.instantiate()
	GameInfo.mainscene.itemNode.add_child(tearBall)
	tearBall.init(global_position, explodeNum, damage.copy(), tearBallScene, maxStack)

func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		area.get_parent().be_hit(damage.copy())
		if canGenerate:
			generate()
		
		delete()
		
