extends HitArea

@onready var hitbox = $Hitbox
var angVel: float = 0
var radius: int = 0
var maxHit: int = 0

var phase: float = 0
var radiusMove: bool = false
var baseDamage: int

var hit = 1
var time := 0.0

func _process(delta):
	phase += delta * angVel
	time += delta
	if radiusMove:
		time += delta
		time = fposmod(time, 6.0)
		radius = abs(time * 100 - 300.0) + 150
	position = GameInfo.mainscene.player.global_position + \
				Vector2.from_angle(phase) * radius
	
func init(pos: Vector2, phase: float, radius: int, angVel: int, damage: int, maxHit: int, radiusMove: bool):
	self.global_position = pos
	self.phase = phase
	self.radius = radius
	self.angVel = angVel
	self.baseDamage = damage
	self.maxHit = maxHit
	if maxHit == -1:
		hit = 0
		
	self.radiusMove = radiusMove
	
func delete():
	queue_free()

func _on_hitbox_area_entered(area):
	if area.is_in_group("enemy"):
		if maxHit == 0:
			delete()
		maxHit -= hit
		var ene = area.get_parent()
		damage = DamageInfo.new(baseDamage, 0, 
			false,
			1.0, GameInfo.mainscene.player, "Psychic")
		ene.be_hit(damage)
