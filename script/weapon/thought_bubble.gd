extends BaseWeapon

@export var bubbleScene: PackedScene

var bubbleAngVel: float = 2 * PI
var attackInterval: float = 0.6
var radius: int = 150
		
var baseCritRate: float = 0
var baseCritDamage: float = 1.5

var bubbleNum: int = 3
var bubbleMaxHit: int = 5
var bubbleRadiusMove: bool = false

var bubbleList = []
	
func _ready():
	hide()
	
func upgrade():
	if self.level <= 3:
		self.level += 1
		match self.level:
			1: self.bubbleNum += 1
			2: self.bubbleNum += 2
			3: self.bubbleMaxHit = -1
			4: 
				self.bubbleRadiusMove = true
				self.bubbleNum += 2
		
func attack():	
	var bubble: Node
	for item in bubbleList:
		if is_instance_valid(item):
			return
	bubbleList = []
	
	self.audioPlayer.play()
	for i in range(bubbleNum):
		bubble = bubbleScene.instantiate()
		GameInfo.mainscene.bulletNode.add_child(bubble)

		bubble.init(global_position, 2 * PI * i / bubbleNum, radius,
				bubbleAngVel, int(calculate_damage()), bubbleMaxHit, bubbleRadiusMove)
				
		bubbleList.append(bubble)
	
func calculate_damage():
	return 3 + 2 * self.level + 0.1 * self.player.charisma + 0.2 * self.player.insight
