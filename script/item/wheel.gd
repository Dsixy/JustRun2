extends HitArea

@onready var sprite = $Sprite2D2
@onready var area = $Area2D
@onready var timer = $Timer
var speed: int = 700
var runDist: int = 700
var attackInterval: float = 0.8
var wheelDamage: DamageInfo
var angVel: float = 10

var maxMove: int = 3
var light: bool = false
signal death(node)

func _process(delta):
	self.rotation += angVel * delta

func init(pos: Vector2, target: Vector2, speed: int, range: float, 
		damage: DamageInfo, wheelDamage: DamageInfo, maxRun: int, light: bool, maxDist: int):
	self.global_position = pos
	self.speed = speed
	self.damage = damage
	self.wheelDamage = wheelDamage
	self.scale *= range
	self.maxMove = maxRun
	self.light = light
	self.runDist = maxDist
		
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target, 0.6)
	self.maxMove -= 1
	self.timer.start(attackInterval)
	
func delete():
	death.emit(self)
	queue_free()
	
func run(target: Vector2):
	if light:
		var enemies = area.get_overlapping_areas()
		var lightDamage: DamageInfo = wheelDamage.duplicate()
		lightDamage.baseAmount = 20
		lightDamage.damageType = "Lightning"
		for e in enemies:
			if e.is_in_group("enemy"):
				var d = lightDamage.copy()
				e.get_parent().be_hit(d)
		self.scale *= 1.5
		self.angVel *= 2
		self.sprite.show()
		await get_tree().create_timer(0.3).timeout
		self.scale /= 1.5
		self.angVel /= 2
		self.sprite.hide()
	
	var tween = get_tree().create_tween()	
	var direction: Vector2 = (target - global_position).normalized()
	tween.tween_property(self, "global_position", self.global_position+self.runDist * direction, 0.4)
	self.maxMove -= 1
	
	if self.maxMove <= 0:
		delete()

func _on_area_2d_area_entered(area):
	var e = area.get_parent()
	if area.is_in_group("enemy"):
		var d = damage.copy()
		e.be_hit(d)

func _on_timer_timeout():
	var enemies = area.get_overlapping_areas()
	for e in enemies:
		if e.is_in_group("enemy"):
			var d = wheelDamage.copy()
			e.get_parent().be_hit(d)
