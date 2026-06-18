extends RefCounted
class_name DamageTypes

## 代码内统一类型键；文档中文见 DISPLAY_NAMES
const PHYSICAL := "Physical"
const FIRE := "Fire"
const ICE := "Ice"
const LIGHTNING := "Lightning"
const POISON := "Poison"
const PSYCHIC := "Psychic"

const DISPLAY_NAMES := {
	PHYSICAL: "物理伤害",
	FIRE: "火焰伤害",
	ICE: "冰霜伤害",
	LIGHTNING: "雷电伤害",
	POISON: "毒素伤害",
	PSYCHIC: "心灵伤害",
}

const COLORS := {
	PHYSICAL: Color8(255, 255, 0),
	FIRE: Color8(255, 0, 0),
	ICE: Color8(0, 0, 255),
	LIGHTNING: Color8(0, 150, 255),
	POISON: Color8(0, 255, 0),
	PSYCHIC: Color8(255, 150, 200),
}

## 旧文档/占位：贯穿、劈砍、力场等均视为物理
const LEGACY_PHYSICAL_ALIASES: Array[String] = [
	"Pierce", "Slash", "Blunt", "Force",
	"贯穿", "劈砍", "力场", "钝击",
]

static func normalize(type: String) -> String:
	if type == "" or type in LEGACY_PHYSICAL_ALIASES:
		return PHYSICAL
	if type in DISPLAY_NAMES:
		return type
	return PHYSICAL

static func display_name(type: String) -> String:
	return DISPLAY_NAMES.get(normalize(type), DISPLAY_NAMES[PHYSICAL])

static func color(type: String) -> Color:
	return COLORS.get(normalize(type), COLORS[PHYSICAL])

static func is_elemental(type: String) -> bool:
	return normalize(type) != PHYSICAL
