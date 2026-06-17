extends Control

@onready var expBar = $PlayerStats/Container/VBoxContainer/ExpBar
@onready var HPBar = $PlayerStats/Container/VBoxContainer/HPBar
@onready var waveLabel = $WaveStats/VBoxContainer/WaveLabel
@onready var timeLabel = $WaveStats/VBoxContainer/TimeLabel
@onready var levelLabel = $PlayerStats/Container/PanelContainer/LevelBoard/LevelLabel
@onready var moneyLabel = $PlayerStats/Container/VBoxContainer/HBoxContainer/Label
@onready var atlas = $PlayerStats/Container/PanelContainer/BackBoard
@onready var shortcutHints = $ShortcutHints

var player: BasePlayer

func _ready() -> void:
	shortcutHints.text = "B 背包/武器  ·  M 能力点  ·  T 图鉴  ·  Esc 菜单"

func _process(_delta):
	expBar.max_value = player.expRequire[player.level]
	expBar.value = player.expValue
	HPBar.max_value = player.maxHP
	HPBar.value = player.HP
	waveLabel.text = "第 %d 波" % GameInfo.get_run_wave()
	timeLabel.text = "剩余时间: %d" % int(GameInfo.get_run_wave_time_left())
	levelLabel.text = str(player.level)
	moneyLabel.text = "%.1f" % player.money
