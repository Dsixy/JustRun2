extends HitArea

@onready var sprite = $Sprite2D
@onready var area = $Area2D

const speed := 2000
var maxDistance: int = 1000
var currentDistance: float = 0.0
var direction: Vector2
var player: BasePlayer
var finish: bool = false

func _process(delta):
	if finish:
		rotation = 0
	else:
		position += direction * speed * delta
		currentDistance += delta * speed
		if currentDistance >= maxDistance:
			finish = true
	
func init(pos: Vector2, direction: Vector2, maxDistance: int, damage: DamageInfo, player: BasePlayer):
	self.global_position = pos
	self.direction = direction
	self.maxDistance = maxDistance
	self.damage = damage
	self.player = player
	rotation = direction.angle() - PI / 2
	
func delete():
	queue_free()
	
func come_back():
	set_process(false)
	rotation = (player.global_position - global_position).angle() - PI / 2
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", player.global_position, 0.3)
	tween.tween_callback(delete)

func _on_area_2d_area_entered(area):
	var e = area.get_parent()
	if area.is_in_group("enemy"):
		var d = damage.copy()
		e.be_hit(d)
