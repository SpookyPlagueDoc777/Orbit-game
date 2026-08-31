extends HBoxContainer

@onready var line_edit: LineEdit = $LineEdit
@onready var sprite: AnimatedSprite2D = $SatelliteSprite
@onready var upgrade_num: Label = $UpgradeNum
@onready var upgrade_button: Button = $UpgradeContainer/UpgradeButton

var current_price: int = 100
var the_satellite: Node = null


func _ready() -> void:
	if Global.has_signal("updatelist"):
		Global.updatelist.connect(_on_update_necessary)


func setup_info(satellites: Node, double: bool = false) -> void:
	update_info(satellites, double)


func update_info(satellites: Node, double: bool = false) -> void:
	if not is_instance_valid(satellites):
		return
		
	the_satellite = satellites
	
	if is_instance_valid(sprite):
		match satellites.satellitetype:
			"Spin":
				sprite.animation = "spin_satellite"
			"Shield":
				sprite.animation = "shield_satellite"
			"Power":
				sprite.animation = "power_satellite"
		sprite.play()

	if is_instance_valid(line_edit):
		line_edit.text = satellites.satellitename
		
	current_price = the_satellite.upgrade * 50 + 100
	var calculated_cost := current_price / 2 if double else current_price
	Global.upgrade_all += calculated_cost
	
	_update_ui_labels(false)


func _update_ui_labels(animate: bool = false) -> void:
	if not is_instance_valid(the_satellite):
		return
		
	var old_num := upgrade_num.text
	var new_num := str(the_satellite.upgrade)
	upgrade_num.text = new_num
	
	current_price = the_satellite.upgrade * 50 + 100
	upgrade_button.text = "Upgrade\n" + str(current_price)

	if animate and old_num != new_num:
		_animate_level_punch()


func _on_line_edit_text_changed(new_text: String) -> void:
	if is_instance_valid(the_satellite):
		the_satellite.satellitename = new_text


func _on_upgrade_button_pressed() -> void:
	if not is_instance_valid(the_satellite):
		return
		
	current_price = the_satellite.upgrade * 50 + 100

	if current_price <= Global.energy:
		SoundManager.successful_push()
		
		# UI Button punch animation
		var btn_tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		btn_tween.tween_property(upgrade_button, "scale", Vector2(0.9, 0.9), 0.05)
		btn_tween.tween_property(upgrade_button, "scale", Vector2.ONE, 0.1)

		upgrade()
	else:
		SoundManager.unsuccessful_push()
		
		# Denied button shake animation
		var shake_tween := create_tween().set_trans(Tween.TRANS_SINE)
		shake_tween.tween_property(upgrade_button, "position:x", upgrade_button.position.x + 5.0, 0.04)
		shake_tween.tween_property(upgrade_button, "position:x", upgrade_button.position.x - 5.0, 0.04)
		shake_tween.tween_property(upgrade_button, "position:x", upgrade_button.position.x, 0.04)


func upgrade() -> void:
	if not is_instance_valid(the_satellite):
		return

	current_price = the_satellite.upgrade * 50 + 100

	if current_price <= Global.energy:
		Global.energy -= current_price
		the_satellite.upgrade += 1
		
		_spawn_row_popup("+1 LVL!", Color(1.0, 0.9, 0.1))
		_update_ui_labels(true)
		
		# THIS BROADCASTS TO THE WORLD AND TRIGGERS THE SATELLITE'S BOUNCE/GLOW/TEXT
		if Global.has_signal("satellite_upgraded"):
			Global.satellite_upgraded.emit(the_satellite)
		
		if Global.has_signal("updatelist"):
			Global.updatelist.emit()


func _on_update_necessary() -> void:
	if is_instance_valid(the_satellite):
		line_edit.text = the_satellite.satellitename
		_update_ui_labels(true)


func _animate_level_punch() -> void:
	upgrade_num.pivot_offset = upgrade_num.size / 2.0
	
	var tween := create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	upgrade_num.scale = Vector2(1.6, 1.6)
	upgrade_num.modulate = Color(1.0, 0.9, 0.1, 1.0)
	
	tween.tween_property(upgrade_num, "scale", Vector2.ONE, 0.22)
	tween.tween_property(upgrade_num, "modulate", Color.WHITE, 0.22)


func _spawn_row_popup(txt: String, color: Color) -> void:
	var label := Label.new()
	label.text = txt
	label.global_position = upgrade_button.global_position + Vector2(-10, -10)
	label.z_index = 100
	
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 6)
	
	get_tree().current_scene.add_child(label)
	label.pivot_offset = label.size / 2.0
	
	var tween := label.create_tween().set_parallel(true)
	
	tween.tween_property(label, "global_position:y", label.global_position.y - 40.0, 0.5)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
		
	label.scale = Vector2(0.5, 0.5)
	tween.tween_property(label, "scale", Vector2(1.3, 1.3), 0.12)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	tween.chain().tween_property(label, "scale", Vector2.ZERO, 0.25)\
		.set_delay(0.1)\
		.set_trans(Tween.TRANS_QUAD)
		
	tween.chain().finished.connect(label.queue_free)
