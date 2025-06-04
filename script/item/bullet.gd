class_name Bullet extends CharacterBody2D

@onready var inScreen = $VisibleOnScreenNotifier2D
@onready var hitbox = $Hitbox
var direction: Vector2 = Vector2.ZERO
var speed: int = 0
var damage: DamageInfo
var pierce: int = 0
var max_path: int = 3000

func _physics_process(delta):
	velocity = direction * speed
	move_and_collide(delta * velocity)
	max_path -= speed * delta
	if max_path < 0:
		delete()
	
func init(pos: Vector2, direction: Vector2, speed: int, damage: DamageInfo, layer: int = 3):
	self.global_position = pos
	self.direction = direction.normalized()
	self.speed = speed
	self.damage = damage
	self.hitbox.set_collision_mask_value(layer, true)
	
func delete():
	queue_free()

func _on_hitbox_area_entered(area):
	if area.is_in_group("enemy"):
		if pierce <= 0:
			delete()
		pierce -= 1
		area.get_parent().be_hit(damage)
	elif area.is_in_group("player"):
		area.get_parent().take_damage(damage)
		delete()
