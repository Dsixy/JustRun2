extends HitArea

var range: float = 1.0
var direction: Vector2
var speed:= 100
@onready var area = $Area2D
@onready var particle = $CPUParticles2D
@onready var frostBiteBuff = preload("res://scene/buff/frost_bite_buff.tscn")

func _ready():
	pass # Replace with function body.
	
func _process(delta):
	global_position += direction * speed * delta

func init(pos: Vector2, direction: Vector2, range: float, damage: DamageInfo):
	self.global_position = pos
	self.direction = direction
	self.damage = damage
	self.range = range
	self.scale *= self.range
	particle.emitting = true
	
func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		var enemy = area.get_parent()
		enemy.be_hit(damage)
		var buff = frostBiteBuff.instantiate()
		buff.set_up(GameInfo.mainscene.player)
		enemy.buffManager.add_buff(buff)
		
		enemy.extraVel = -(enemy.global_position - global_position)

func _on_cpu_particles_2d_finished():
	queue_free()
