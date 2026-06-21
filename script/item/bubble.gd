extends HitArea

const DamageTypes = preload("res://script/damage_types.gd")

@onready var hitbox = $Hitbox
var angVel: float = 0
var radius: int = 0
var maxHit: int = 0

var phase: float = 0
var radiusMove: bool = false
var baseDamage: int

var hit = 1
var time := 0.0
var critRate: float = 0.05
var critDamage: float = 1.5
var damageSource: Node = null

func _process(delta):
	phase += delta * angVel
	time += delta
	if radiusMove:
		time += delta
		time = fposmod(time, 6.0)
		radius = abs(time * 100 - 300.0) + 150
	position = GameInfo.mainscene.player.global_position + \
				Vector2.from_angle(phase) * radius
	
func init(pos: Vector2, phase: float, radius: int, angVel: int, damage: int, maxHit: int, radiusMove: bool,
		p_crit_rate: float = 0.05, p_crit_damage: float = 1.5, source: Node = null):
	self.global_position = pos
	self.phase = phase
	self.radius = radius
	self.angVel = angVel
	self.baseDamage = damage
	self.maxHit = maxHit
	self.critRate = p_crit_rate
	self.critDamage = p_crit_damage
	self.damageSource = source if source else GameInfo.mainscene.player
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
			randf() < critRate,
			critDamage, damageSource, DamageTypes.PSYCHIC)
		ene.be_hit(damage)
