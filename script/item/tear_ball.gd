extends Node2D

@onready var tearBulletScene: PackedScene = preload("res://scene/item/tear_bullet.tscn")
@onready var timer = $Timer
var tearBallScene: PackedScene
var curStack: int = 0
var maxStack: int = 4
var tearNum: int = 4
var tearDamage: DamageInfo

func init(pos: Vector2, explodeNum: int, damage: DamageInfo, tearBallScene: PackedScene, maxStack: int):
	global_position = pos
	tearNum = explodeNum
	tearDamage = damage
	self.tearBallScene = tearBallScene
	self.maxStack = maxStack
	
func explode(hitDirec: Vector2=Vector2.ZERO):
	var len = len(GameInfo.mainscene.bulletNode.get_children())
	if len >= 100:
		tearNum = int(tearNum * 0.35)
	elif len >= 60:
		tearNum = int(tearNum * 0.7)
		
	for i in range(tearNum):
		var bullet = tearBulletScene.instantiate()
		var direction = Vector2.from_angle(i * 2 * PI / tearNum)
		GameInfo.mainscene.bulletNode.add_child(bullet)
		bullet.init(global_position, direction, 400, tearDamage.copy(),
		1000, tearNum, tearBallScene, false)
		
	call_deferred("queue_free")
	
func _on_area_2d_area_entered(area):
	if area.is_in_group("TearBullet"):
		var bullet = area.get_parent()
		bullet.delete()
		curStack += 1
		self.scale = (curStack * 0.3 + 0.4) * Vector2.ONE
		timer.start(5.0)
		if curStack >= maxStack:
			explode((area.global_position - global_position).normalized())

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func _on_timer_timeout():
	queue_free()
