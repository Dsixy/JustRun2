extends HitArea

@onready var area = $Area2D
var maxRadius: int = 200
var pick: bool = false
var knock: bool = false

func _ready():
	self.scale = Vector2(0, 0)
	self.modulate = Color8(100, 255, 100, 200)
	
func init(pos: Vector2, maxRadius: int, damage: DamageInfo, knock: bool, pick: bool):
	self.global_position = pos
	self.maxRadius = maxRadius
	self.damage = damage
	self.knock = knock
	self.pick = pick
	if pick:
		area.set_collision_mask_value(2, true)
	spread()
	
func spread():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", maxRadius / 100 * Vector2(1, 1), 0.6)
	tween.tween_callback(queue_free)

func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		var ene = area.get_parent()
		ene.be_hit(damage.copy())
		if knock:
			ene.extraVel = (area.global_position - self.global_position).normalized() * 1000
			
	elif area.is_in_group("expGem"):
		damage.source.pick(area)
