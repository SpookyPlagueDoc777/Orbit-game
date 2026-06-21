extends Control
#
#@onready var clicksound: AudioStreamPlayer = $"../Audio/Clicksound"
#@onready var vhs_shader_effect: ColorRect = $"../VHS_shader_effect"
#@onready var vsync_button: Button = $SettingsContainer/Visuals/VisualScrollContainer/ScrollListVisuals/VSyncContainer/VsyncButton
#
#
#var vsync: int = 0
#
#func _ready() -> void:
	#vsync_button.text = "Enabled"
	#
#func _on_back_pressed() -> void:
	#$".".visible = false
	#Global.updatemenu.emit(Global.menus.PAUSE)
	#clicksound.play()
#
#func _on_main_vol_slider_value_changed(value: float) -> void:
	#AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)
#
#
#func _on_sfx_vol_slider_value_changed(value: float) -> void:
	#AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), value)
#
#
#func _on_music_vol_slider_value_changed(value: float) -> void:
	#AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), value)
#
#func _on_vhs_switch_toggled(toggled_on: bool) -> void:
	#if toggled_on == true:
		#vhs_shader_effect.visible = true
	#if toggled_on == false:
		#vhs_shader_effect.visible = false
#
#
#func _on_vsync_button_pressed() -> void:
	#match DisplayServer.window_get_vsync_mode():
		#DisplayServer.VSYNC_ENABLED:
			#vsync_button.text = "Disabled"
			#DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		#DisplayServer.VSYNC_DISABLED:
			#vsync_button.text = "Adaptive"
			#DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
		#DisplayServer.VSYNC_ADAPTIVE:
			#vsync_button.text = "Mailbox"
			#DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_MAILBOX)
		#DisplayServer.VSYNC_MAILBOX:
			#vsync_button.text = "Enabled"
			#DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
