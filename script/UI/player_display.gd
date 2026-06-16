extends Control

const CHARACTER_INFO := {
	"aho": {
		"name": "阿猴",
		"tagline": "均衡新手 · 手枪起手",
		"unlock_hint": "",
	},
	"carmor": {
		"name": "卡莫",
		"tagline": "低血高机动 · 激光枪",
		"unlock_hint": "解锁：抵达第 3 波 · 初遇卡莫",
	},
	"alew": {
		"name": "阿女",
		"tagline": "拾取发育 · 花刀玉手",
		"unlock_hint": "解锁：抵达第 6 波 · 初遇阿女",
	},
}

@onready var content = $Panel/Control
@onready var name_label: Label = $NameLabel
@onready var tagline_label: Label = $TaglineLabel

var player: BasePlayer
var playerPath: String
var character_key: String = ""
var is_locked: bool = false
signal onclick(node: Control)

func init(p: String, locked: bool = false) -> void:
	playerPath = p
	is_locked = locked
	character_key = GameInfo.get_character_key_from_path(p)
	player = load(p).instantiate()
	content.add_child(player)
	process_player()
	_apply_character_info()
	set_highlight(false)

func process_player() -> void:
	if player:
		player.set_physics_process(false)
		player.set_process(false)
		player.set_process_unhandled_input(false)
		player.camera.enabled = false

func _apply_character_info() -> void:
	var info: Dictionary = CHARACTER_INFO.get(character_key, {})
	name_label.text = info.get("name", character_key)
	if is_locked:
		tagline_label.text = info.get("unlock_hint", "未解锁")
	else:
		tagline_label.text = info.get("tagline", "")
	$Button.disabled = is_locked

func set_highlight(selected: bool) -> void:
	if is_locked:
		modulate = Color8(90, 90, 90)
	elif selected:
		modulate = Color8(255, 255, 255)
	else:
		modulate = Color8(130, 130, 130)

func _on_button_pressed() -> void:
	if is_locked:
		return
	onclick.emit(self)
	GameInfo.player = playerPath
