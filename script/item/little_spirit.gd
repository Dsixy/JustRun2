extends Node2D

@export var hitAreaScene: PackedScene
var direction: Vector2
var speed: int = 100
var HP: int = 20
var baseDamage: int
var radiusBonus: float
var level: int = 0
var critRate: float = 0.05
var critDamage: float = 1.5
var damageSource: Node = null
signal disappear(n: Node)

func _process(delta):
	position += direction * speed * delta
	
func init(pos: Vector2, radiusBonus: float, HP: int, baseDamage, level: int = 0,
		p_crit_rate: float = 0.05, p_crit_damage: float = 1.5, source: Node = null):
	$Sprite2D.frame = randi() % 2
	self.global_position = pos
	self.radiusBonus = radiusBonus
	self.HP = HP
	self.direction = Vector2.from_angle(randf() * PI * 2)
	self.baseDamage = baseDamage
	self.level = level
	self.critRate = p_crit_rate
	self.critDamage = p_crit_damage
	self.damageSource = source
	
func gainPower(n: int):
	self.HP += n * 10
	var hitArea = hitAreaScene.instantiate()
	GameInfo.mainscene.effectNode.add_child(hitArea)
	hitArea.init(global_position, radiusBonus + 0.6, n * 10 + baseDamage,
		critRate, critDamage, damageSource)
	hitArea.damage.isCrit = true
	
func take_damage(damage:DamageInfo):
	self.HP -= damage.finalDamage
	var hitArea = hitAreaScene.instantiate()
	GameInfo.mainscene.effectNode.add_child(hitArea)
	hitArea.init(global_position, radiusBonus, damage.baseAmount * 0.2 * level + baseDamage,
		critRate, critDamage, damageSource)
	self.direction = Vector2.from_angle(randf() * PI * 2)
	if self.HP <= 0:
		delete()
		
func delete():
	disappear.emit(self)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	delete()
