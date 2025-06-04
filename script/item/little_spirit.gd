extends Node2D

@export var hitAreaScene: PackedScene
var direction: Vector2
var speed: int = 100
var HP: int = 20
var baseDamage: int
var radiusBonus: float
signal disappear(n: Node)

func _process(delta):
	position += direction * speed * delta
	
func init(pos: Vector2, radiusBonus: float, HP: int, baseDamage):
	$Sprite2D.frame = randi() % 2
	self.global_position = pos
	self.radiusBonus = radiusBonus
	self.HP = HP
	self.direction = Vector2.from_angle(randf() * PI * 2)
	self.baseDamage = baseDamage
	
func gainPower(n: int):
	self.HP += n * 10
	var hitArea = hitAreaScene.instantiate()
	GameInfo.mainscene.effectNode.add_child(hitArea)
	hitArea.init(global_position, radiusBonus + 0.6, n * 10 + baseDamage)
	hitArea.damage.isCrit = true
	
func take_damage(damage:DamageInfo):
	self.HP -= damage.finalDamage
	var hitArea = hitAreaScene.instantiate()
	GameInfo.mainscene.effectNode.add_child(hitArea)
	hitArea.init(global_position, radiusBonus, damage.baseAmount + baseDamage)
	self.direction = Vector2.from_angle(randf() * PI * 2)
	if self.HP <= 0:
		delete()
		
func delete():
	disappear.emit(self)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	delete()
