class_name BaseWeapon extends Sprite2D

var level: int = 0
var baseDamage: Array[int] = [0, 0, 0, 0, 0]
var player: BasePlayer = null
@export var id: int = 0
@onready var audioPlayer = $AudioStreamPlayer
@export var na: String
@export var descriptions: Array[String]
var description: String:
	get:
		return descriptions[level]

func update_player(player: BasePlayer):
	self.player = player
	
func attack():
	pass

# To process the drag event
func process_slot(cur: Node, drag: Node):
	if cur == drag:
		return [null, cur]
	elif is_instance_of(cur, BaseWeapon):
		if drag.id == cur.id and drag.level == cur.level and drag.level < 4:
			cur.upgrade()
			return [cur, null]
	
	return [drag, cur]
	
func upgrade():
	pass
	
func arm(weaponArm: BaseWeaponArm):
	pass
	
func dearm():
	pass
	
func follow_up_attack():
	pass
