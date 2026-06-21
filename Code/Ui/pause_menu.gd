extends Control

@onready var resume: Button = $Pause_menu/Panel/VBoxContainer/resume
@onready var settings: Button = $Pause_menu/Panel/VBoxContainer/settings
@onready var quit: Button = $Pause_menu/Panel/VBoxContainer/quit
@onready var clicksound: AudioStreamPlayer = $"../Audio/Clicksound"

func _ready() -> void:
	pass

func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false
	clicksound.play()

func _on_settings_pressed() -> void:
	Global.updatemenu.emit(Global.menus.SETTINGS)
	clicksound.play()
	
func _on_quit_pressed() -> void:
	clicksound.play()
	get_tree().quit()
