extends Control

signal closed

@onready var resume_button = $Panel/MarginContainer/VBoxContainer/ResumeButton
@onready var restart_button = $Panel/MarginContainer/VBoxContainer/RestartButton
@onready var settle_button = $Panel/MarginContainer/VBoxContainer/SettleButton
@onready var main_menu_button = $Panel/MarginContainer/VBoxContainer/MainMenuButton

func init(_player: BasePlayer, _cfg_dict: Dictionary = {}) -> void:
	resume_button.grab_focus()

func _on_resume_button_pressed() -> void:
	emit_signal("closed")

func _on_restart_button_pressed() -> void:
	var run_scene := GameInfo.get_run_scene()
	if run_scene:
		run_scene.restart_run()

func _on_settle_button_pressed() -> void:
	var run_scene := GameInfo.get_run_scene()
	if run_scene:
		emit_signal("closed")
		run_scene.early_settle()

func _on_main_menu_button_pressed() -> void:
	var run_scene := GameInfo.get_run_scene()
	if run_scene:
		emit_signal("closed")
		run_scene.quit_to_main_menu()

func close_board() -> void:
	queue_free()
