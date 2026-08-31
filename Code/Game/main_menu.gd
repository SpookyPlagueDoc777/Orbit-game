extends Node2D

const UI_THEME = preload("uid://dn5wefao8u26i")
@onready var music: AudioStreamPlayer = $music


func _ready() -> void:
	if OS.has_feature("web"):
		$Spaceeee/Button2.hide()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game/main_node.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()


func _on_reset_progress_button_pressed() -> void:
	if not SaveManager.has_save():
		return
		
	_show_custom_confirm_dialog()


func _show_custom_confirm_dialog() -> void:
	# Root container layer to dim screen background slightly
	var overlay := ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.4)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.z_index = 4096

	# Outer purple window panel
	var panel := PanelContainer.new()
	panel.theme = UI_THEME
	
	var bg_box := StyleBoxFlat.new()
	bg_box.bg_color = Color(0.36, 0.28, 0.63, 0.95)
	bg_box.set_corner_radius_all(8)
	bg_box.border_width_left = 4
	bg_box.border_width_top = 4
	bg_box.border_width_right = 4
	bg_box.border_width_bottom = 4
	bg_box.border_color = Color(0.63, 0.58, 0.89, 1.0)
	bg_box.content_margin_left = 24.0
	bg_box.content_margin_top = 20.0
	bg_box.content_margin_right = 24.0
	bg_box.content_margin_bottom = 20.0
	panel.add_theme_stylebox_override("panel", bg_box)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)

	# Larger Title
	var title := Label.new()
	title.text = "Reset Progress"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", Color(0.9, 0.95, 0.4, 1.0))

	# Larger Description Body
	var body := Label.new()
	body.text = "Are you sure you want to delete all saved progress?"
	body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	body.add_theme_font_size_override("font_size", 26)
	body.add_theme_color_override("font_color", Color(1, 1, 1, 1))

	# Buttons Container
	var hbox := HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 24)

	var confirm_btn := Button.new()
	confirm_btn.text = " OK "
	confirm_btn.add_theme_font_size_override("font_size", 26)
	confirm_btn.custom_minimum_size = Vector2(80, 36)

	var cancel_btn := Button.new()
	cancel_btn.text = " Cancel "
	cancel_btn.add_theme_font_size_override("font_size", 26)
	cancel_btn.custom_minimum_size = Vector2(80, 36)

	hbox.add_child(confirm_btn)
	hbox.add_child(cancel_btn)

	vbox.add_child(title)
	vbox.add_child(body)
	vbox.add_child(hbox)
	panel.add_child(vbox)
	overlay.add_child(panel)
	add_child(overlay)

	# Center the dialog on screen
	await get_tree().process_frame
	panel.pivot_offset = panel.size / 2.0
	panel.position = (get_viewport_rect().size / 2.0) - (panel.size / 2.0)

	# Button handlers
	confirm_btn.pressed.connect(func():
		SaveManager.delete_save()
		if SoundManager.has_method("successful_push"):
			SoundManager.successful_push()
		overlay.queue_free()
	)

	cancel_btn.pressed.connect(func():
		overlay.queue_free()
	)


func _on_music_finished() -> void:
	music.play()
