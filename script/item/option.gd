extends Node2D

@export var bulletScene: PackedScene
@onready var timer = $Timer
var weapon: BaseWeapon
var shootAccuracy: float = 0.8
var bulletSpeed: int = 700
var damage: DamageInfo
var move: bool = false
var auto: bool = false
var player: BasePlayer

func _ready():
	pass # Replace with function body.
	
func init(pos: Vector2, player: BasePlayer, move: bool, auto: bool, damage: DamageInfo, weapon):
	self.global_position = pos
	self.player = player
	self.move = move
	self.auto = auto
	self.damage = damage
	if weapon is BaseWeapon:
		self.equip(weapon)
	if auto and self.weapon:
		timer.start(self.weapon.attackInterval)
	
func attack():
	var target = get_global_mouse_position()
	if move and randf() > 0.8:
		await redirect(target)
		
	if self.weapon is BaseWeapon:
		self.weapon.attack()
	else:
		var direction: Vector2 = (target - self.global_position).normalized()
		var bullet = bulletScene.instantiate()
		GameInfo.mainscene.bulletNode.add_child(bullet)
		
		var bias: Vector2 = direction.orthogonal() * (randf() * 2 - 1) * (1 - shootAccuracy)
		bullet.init(global_position, direction + bias, bulletSpeed, self.damage.copy())

func redirect(pos: Vector2):
	var target_pos = pos + Vector2.from_angle(randf() * 2 * PI) * 300
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target_pos, 0.8)
	
func equip(weapon: BaseWeapon):
	self.weapon = weapon
	add_child(weapon)
	self.weapon.update_player(self.player)
	
func de_equip():
	remove_child(self.weapon)
	self.weapon = null

func _on_timer_timeout():
	self.attack()
