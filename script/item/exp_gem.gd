extends Pickable

var level: int


func _ready():
	pass
	
func init(level: int, pos: Vector2):
	self.level = level
	self.global_position = pos
	sprite.frame = self.level
