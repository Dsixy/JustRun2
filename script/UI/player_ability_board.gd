extends Control

@export var abilityScene: PackedScene
const properties = [
	"stamina", "strength",
	"insight", "agility",
	"charisma", "perception",
	"resilience", "dexterrity",
]

const prop_to_idx = {
	"stamina": 2, "strength" : 4,
	"insight": 3, "agility": 5,
	"charisma": 6, "perception": 8,
	"resilience": 7, "dexterrity": 0,
}
const prop_to_modu = {
	"stamina": Color8(203, 211, 0), "strength" : Color8(96, 217, 255),
	"insight": Color8(165, 223, 0), "agility": Color8(167, 255, 239),
	"charisma": Color8(191, 118, 255), "perception": Color8(0, 86, 251),
	"resilience": Color8(0, 224, 108), "dexterrity": Color8(255, 163, 67),
}

const prop_to_desp = {
	"stamina": "体力。用于提升角色最大生命值，部分武器伤害以及效果受体力加成",
	"strength" : "力量。用于提升部分近战武器伤害",
	"insight": "启迪。用于提升法术类武器伤害，部分DOT效果也受到启迪加成",
	"agility": "敏捷。用于提升角色移速和暴击率",
	"charisma": "魅力。用于提升部分心灵武器伤害，魅力还会降低商店价格",
	"perception": "感知。用于提升拾取范围、金币加成、经验值加成",
	"resilience": "坚韧。用于提升护甲，部分武器伤害受坚韧加成",
	"dexterrity": "熟练。用于提升部分武器攻速与拾取范围，部分武器伤害受熟练加成",
}

var player: BasePlayer
var abilityDict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(8):
		var ability = abilityScene.instantiate()
		add_child(ability)
		ability.init(properties[i], prop_to_idx[properties[i]],
		prop_to_modu[properties[i]], prop_to_desp[properties[i]], 4)
		ability.set_available(true)
		ability.position = Vector2.from_angle(i * PI / 4) * 200
		
		abilityDict[self.properties[i]] = ability
		ability.connect("click", ability_clicked)

func init(player: BasePlayer):
	self.player = player
	for item in abilityDict:
		abilityDict[item].value = player.get(item)
		abilityDict[item].set_available(player.abilityPoint > 0)
		
	var playerIcon = player.sprite.duplicate()
	playerIcon.scale = Vector2(1.2, 1.2)
	add_child(playerIcon)
		
func update_player_ability():
	if player:
		for prop in properties:
			player.set(prop, self.abilityDict[prop].value)
			
		player.update()

func close_board():
	update_player_ability()
	queue_free()
	
func ability_clicked():
	player.abilityPoint -= 1
	for item in abilityDict:
		abilityDict[item].set_available(player.abilityPoint > 0)
