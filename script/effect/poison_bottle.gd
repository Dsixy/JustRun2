extends Sprite2D

@export var poisonAreaScene: PackedScene
var start_pos: Vector2
var target_pos: Vector2
var duration: float = 1.0
var timer: float = 0.0
var height: float = 100
var range: float
var damage: DamageInfo

func init(pos: Vector2, target_pos: Vector2, range: float, \
		damage: DamageInfo):
	self.start_pos = pos
	self.target_pos = target_pos
	self.range = range
	self.damage = damage
	
func _process(delta):
	if timer < duration:
		timer += delta
		var t = timer / duration

		var pos = start_pos.lerp(target_pos, t)
		pos.y -= height * 4 * t * (1 - t) 
		rotation += delta * 10
		global_position = pos
	else:
		spread()
		queue_free()

func spread():
	var poisonArea = poisonAreaScene.instantiate()
	GameInfo.mainscene.effectNode.add_child(poisonArea)
	poisonArea.init(global_position, self.range, self.damage)
	queue_free()
