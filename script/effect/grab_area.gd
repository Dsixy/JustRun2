extends Node2D

@onready var area = $Area2D

var enemyList: Array = []

func init(direction: Vector2):
	rotation = direction.angle()
	
	await get_tree().process_frame
	catch()
	await get_tree().create_timer(0.2).timeout
	throw()
	await get_tree().create_timer(0.3).timeout
	delete()

func catch():
	enemyList = area.get_overlapping_areas()
	print(enemyList)
	for enemy in enemyList:
		enemy.be_knock_back(Vector2.ZERO, 2)
		var tween = get_tree().create_tween()
		tween.tween_property(enemy, "global_position", global_position, 0.3)
	
func throw():
	var direc = (get_global_mouse_position() - global_position).normalized()
	for enemy in enemyList:
		enemy.be_knock_back(direc * 1000, 2)

func delete():
	queue_free()


