class_name BaseWeaponArm extends Node2D

var weaponList = []
var content: Array = []
var isActivate: bool = false
var player: BasePlayer = null
var contentAttackInterval = []
var intervalScale: float = 1.0
var slotScale: float = 3.0

# UI
@export var slotPos: Array[Vector2]
@export var weaponArmBoardTexture: CompressedTexture2D

func _ready():
	pass
	
func _process(delta):
	if isActivate:
		attack()

func attack():
	if player == null:
		return
		
	set_process(false)
	for i in range(len(content)):
		for weapon in content[i]:
			if weapon:
				weapon.attack()
			
		await get_tree().create_timer(self.contentAttackInterval[i] * intervalScale).timeout
	set_process(true)
	
func activate():
	isActivate = true
	
func deactivate():
	isActivate = false
	
func update_weapons():
	for weapon in get_children():
		if is_instance_of(weapon, BaseWeapon):
			weapon.dearm()
			remove_child(weapon)
			
	for weapon in weaponList:
		if weapon:
			add_child(weapon)
			weapon.update_player(self.player)
			weapon.arm()
	
	update_content()
	
func update_content():
	self.contentAttackInterval = []
	self.content = [[weaponList[0]], [weaponList[1], weaponList[2]], [weaponList[3]]]
	for i in range(len(self.content)):
		var intervals = [0]
		for weapon in self.content[i]:
			if weapon:
				intervals.append(weapon.attackInterval)
		self.contentAttackInterval.append(intervals.max())
