extends HitArea

@onready var sprite = $Sprite2D
@onready var area = $Area2D
var speed: int = 0
var target
var direction: Vector2
var player: BasePlayer
var finish: bool = false
var collection: float = 0
var extraCoin: bool = false
var bringCoin: bool = false

func _process(delta):
	if is_instance_valid(target):
		direction = (target.global_position - self.global_position).normalized()
		sprite.flip_h = direction.x < 0
		position += direction * speed * delta
	else:
		come_back()
	
func init(pos: Vector2, target: BaseEnemy, speed: int, damage: DamageInfo, \
		player: BasePlayer, extraCoin: bool, bringCoin: bool):
	self.global_position = pos
	self.target = target
	self.speed = speed
	self.damage = damage
	self.player = player
	self.extraCoin = extraCoin
	self.bringCoin = bringCoin
	if bringCoin:
		self.area.set_collision_mask_value(2, true)
	
func delete():
	player.gain_coin(collection + int(extraCoin) * 0.2)
	queue_free()
	
func come_back():
	target = player
	finish = true
	if area.get_overlapping_areas().has(player.hurtbox):
		delete()

func _on_area_2d_area_entered(area):
	var e = area.get_parent()
	if area.is_in_group("enemy"):
		var d = damage.copy()
		if self.bringCoin:
			d.baseAmount += collection * 5.0
		e.be_hit(d)
		if e == target:
			come_back()
	elif area.is_in_group("coin"):
		e.queue_free()
		collection += 1
	elif finish and area.is_in_group("player"):
		delete()
