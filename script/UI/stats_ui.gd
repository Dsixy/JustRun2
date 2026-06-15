extends Control

@onready var expBar = $PlayerStats/Container/VBoxContainer/ExpBar
@onready var HPBar = $PlayerStats/Container/VBoxContainer/HPBar
@onready var waveLabel = $WaveStats/VBoxContainer/WaveLabel
@onready var timeLabel = $WaveStats/VBoxContainer/TimeLabel
@onready var levelLabel = $PlayerStats/Container/PanelContainer/LevelBoard/LevelLabel
@onready var moneyLabel = $PlayerStats/Container/VBoxContainer/HBoxContainer/Label
@onready var atlas = $PlayerStats/Container/PanelContainer/BackBoard

var player: BasePlayer

func _process(_delta):
	expBar.max_value = player.expRequire[player.level]
	expBar.value = player.expValue
	HPBar.max_value = player.maxHP
	HPBar.value = player.HP
	waveLabel.text = "第 %d 波" % GameInfo.mainscene.wave
	timeLabel.text = "剩余时间: %d" % int(GameInfo.mainscene.waveTimer.time_left)
	levelLabel.text = str(player.level)
	moneyLabel.text = "%.1f" % player.money
