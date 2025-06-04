extends BaseWeapon

@export var starScene: PackedScene

var attackInterval: float = 0.6
var baseCritRate: float = 0.05
var baseCritDamage: float = 2.0

var starNum: int = 3
var attackRadius: int = 100
var alwaysFall: bool = false
	
func _ready():
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.starNum += 2
			2: self.attackRadius += 0.4
			3: self.starNum += 3
			4: 
				self.attackRadius += 0.6
				self.alwaysFall = true
		
func attack():	
	var targetPositions = get_target_positions()

	for targetPos in targetPositions:
		var star = starScene.instantiate()
		GameInfo.mainscene.effectNode.add_child(star)
		var damage = DamageInfo.new(calculate_damage(), 0, 
			randf() < self.baseCritRate + self.player.critRate,
			self.baseCritDamage, player)
		star.init(targetPos, attackRadius, damage)
	
func get_target_positions():
	var screenArea = Rect2(player.camera.get_screen_center_position() - Vector2(960, 540), Vector2(1920, 1080))
	var posList = []
	var childList = GameInfo.mainscene.bulletNode.get_children()
	var bulletList = []
	for child in childList:
		if screenArea.has_point(child.global_position):
			bulletList.append(child)
	
	if alwaysFall:
		var center_pos = GameInfo.mainscene.player.global_position
		for i in range(self.starNum - len(bulletList)):
			posList.append(center_pos + Vector2(randi() % 1000, randi() % 600) - Vector2(500, 300))
		
	for i in range(min(len(bulletList), starNum)):
		posList.append(bulletList[i].global_position)
		
	return posList
	
func calculate_damage():
	return 7 + 1.5 * self.level * (2 + 0.2 * self.player.insight)
