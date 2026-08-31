extends Control

const SATELLITE_ITEM_SCENE = preload("uid://bb15mu16gd08i")
const FONT = preload("uid://dr3nm75s2psu5")

var last_state: bool

@onready var shop_menu: Control = $Shop_ui/ShopMenu
@onready var pause_button: Button = $PauseButton/PauseButton
@onready var satellite_container: VBoxContainer = $SatelliteList/VBoxContainer/SatelliteScroll/SatelliteContainer
@onready var satellite_container2: VBoxContainer = $Shop_ui/ShopMenu/ActualButtons/SatellitesList/VBoxContainer/SatelliteScroll/SatelliteContainer
@onready var upgrade_all_button: Button = $Shop_ui/ShopMenu/ActualButtons/UpgradeAll/UpgradeAllButton
@onready var save_button: Button = $save/PauseButton

# Camera reference for Screen Shake
@export var camera_2d: Camera2D	


func _ready() -> void:
	if Global.has_signal("updatelist"):
		Global.updatelist.connect(rebuild_all_satellite_lists)
	
	if SaveManager.has_signal("load_completed"):
		SaveManager.load_completed.connect(_on_save_load_completed)
		
	if Global.has_signal("satellite_upgraded"):
		Global.satellite_upgraded.connect(_on_individual_satellite_upgraded)
		
	call_deferred("rebuild_all_satellite_lists")


func _on_individual_satellite_upgraded(sat_node: Node) -> void:
	if is_instance_valid(sat_node):
		# 1. World Popup over satellite in game space
		spawn_floating_text(sat_node.global_position, "LVL UP! [" + str(sat_node.upgrade) + "]", Color(1.0, 0.9, 0.1))
		
		# 2. Center-screen floating popup
		var sat_name: String = sat_node.get_clean_display_name() if sat_node.has_method("get_clean_display_name") else sat_node.name.to_upper()
		spawn_center_floating_text(sat_name + " UPGRADED!", Color(1.0, 0.9, 0.1))
		
		# 3. Juice / Feedback
		shake_camera(14.0, 0.25)
		call_deferred("rebuild_all_satellite_lists")


func _on_save_load_completed(_success: bool) -> void:
	rebuild_all_satellite_lists()


func _process(_delta: float) -> void:
	if shop_menu.visible and is_instance_valid(upgrade_all_button):
		upgrade_all_button.text = "Upgrade All!    " + str(Global.upgrade_all)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not visible:
		_close_shop()


func _on_button_pressed() -> void:
	SoundManager.successful_push()
	visible = false
	
	shop_menu.visible = true
	shop_menu.scale = Vector2(0.85, 0.85)
	shop_menu.modulate.a = 0.0
	
	var tween := create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(shop_menu, "scale", Vector2.ONE, 0.25)
	tween.tween_property(shop_menu, "modulate:a", 1.0, 0.2)
	
	last_state = Global.is_paused
	Global.is_paused = true
	rebuild_all_satellite_lists()


func _on_back_button_pressed() -> void:
	if not visible:
		SoundManager.successful_push()
		_close_shop()


func _close_shop() -> void:
	var tween := create_tween().set_parallel(true).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(shop_menu, "scale", Vector2(0.9, 0.9), 0.15)
	tween.tween_property(shop_menu, "modulate:a", 0.0, 0.15)
	
	await tween.finished
	shop_menu.visible = false
	visible = true
	Global.is_paused = last_state
	pause_button.button_pressed = not last_state
	rebuild_all_satellite_lists()


func rebuild_all_satellite_lists() -> void:
	Global.upgrade_all = 0
	_clear_container(satellite_container)
	_clear_container(satellite_container2)

	var satellites: Array = get_tree().get_nodes_in_group("SatelliteGroup")
	for sat in satellites:
		if is_instance_valid(sat) and not sat.is_queued_for_deletion():
			_populate_row(satellite_container, sat)
			_populate_row(satellite_container2, sat)


func _clear_container(container: VBoxContainer) -> void:
	if not is_instance_valid(container):
		return
	for child in container.get_children():
		child.queue_free()


func _populate_row(container: VBoxContainer, sat_node: Node) -> void:
	if not is_instance_valid(container):
		return
	var item_row = SATELLITE_ITEM_SCENE.instantiate()
	container.add_child(item_row)
	
	item_row.modulate.a = 0.0
	var tween := create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(item_row, "modulate:a", 1.0, 0.18)

	if item_row.has_method("setup_info"):
		item_row.setup_info(sat_node, false)
	elif item_row.has_method("update_info"):
		item_row.update_info(sat_node, false)


func _on_buy_energy_satellite_pressed() -> void:
	_attempt_launch(0, "ENERGY SATELLITE")


func _on_buy_spin_satellite_pressed() -> void:
	_attempt_launch(2, "SPIN SATELLITE")


func _on_buy_shield_satellite_pressed() -> void:
	_attempt_launch(1, "SHIELD SATELLITE")


func _attempt_launch(type_id: int, sat_name: String = "SATELLITE") -> void:
	var launched_sat: Node = SatelliteManager.launch_satellite(type_id)
	if launched_sat != null:
		spawn_floating_text(launched_sat.global_position, "+1 SATELLITE!", Color(0.2, 1.0, 0.4))
		spawn_center_floating_text(sat_name + " BOUGHT!", Color(0.2, 1.0, 0.4))
		
		shake_camera(12.0, 0.25)
		call_deferred("rebuild_all_satellite_lists")


func _on_upgrade_all_button_pressed() -> void:
	if Global.energy >= Global.upgrade_all and Global.upgrade_all > 0:
		SoundManager.successful_push()
		Global.energy -= Global.upgrade_all
		
		var btn_tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		btn_tween.tween_property(upgrade_all_button, "scale", Vector2(0.9, 0.9), 0.05)
		btn_tween.tween_property(upgrade_all_button, "scale", Vector2.ONE, 0.12)

		var satellites: Array = get_tree().get_nodes_in_group("SatelliteGroup")
		for sat in satellites:
			if is_instance_valid(sat) and not sat.is_queued_for_deletion():
				sat.upgrade += 1
				spawn_floating_text(sat.global_position, "LVL UP! [" + str(sat.upgrade) + "]", Color(1.0, 0.9, 0.1))

		spawn_center_floating_text("ALL SATELLITES UPGRADED!", Color(1.0, 0.85, 0.1))
		shake_camera(20.0, 0.35)
		
		call_deferred("rebuild_all_satellite_lists")
	else:
		SoundManager.unsuccessful_push()
		
		var shake_tween := create_tween().set_trans(Tween.TRANS_SINE)
		shake_tween.tween_property(upgrade_all_button, "position:x", upgrade_all_button.position.x + 8.0, 0.04)
		shake_tween.tween_property(upgrade_all_button, "position:x", upgrade_all_button.position.x - 8.0, 0.04)
		shake_tween.tween_property(upgrade_all_button, "position:x", upgrade_all_button.position.x, 0.04)


func _on_pause_button_pressed() -> void:
	SaveManager.save_game()
	show_save_notification()


func show_save_notification() -> void:
	var label: Label = get_node_or_null("SaveNotification")
	if not label:
		return

	label.modulate.a = 0.0
	label.scale = Vector2(0.8, 0.8)

	var tween := create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.25)
	tween.parallel().tween_property(label, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_interval(1.0)
	tween.tween_property(label, "modulate:a", 0.0, 0.5)


# --- UTILITIES & POPUPS ---

func _get_target_camera() -> Camera2D:
	if is_instance_valid(camera_2d):
		return camera_2d
	return get_viewport().get_camera_2d()


func shake_camera(intensity: float = 18.0, duration: float = 0.3) -> void:
	var cam := _get_target_camera()
	if not is_instance_valid(cam):
		return
		
	var tween := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	var steps := int(duration / 0.03)
	var initial_offset := cam.offset
	
	for i in range(steps):
		var damping: float = 1.0 - (float(i) / float(steps))
		var shake_offset := Vector2(
			randf_range(-intensity, intensity) * damping,
			randf_range(-intensity, intensity) * damping
		)
		tween.tween_property(cam, "offset", initial_offset + shake_offset, 0.03)
		
	tween.tween_property(cam, "offset", initial_offset, 0.03)


func spawn_floating_text(global_pos: Vector2, text_value: String, color: Color) -> void:
	var label := Label.new()
	label.text = text_value
	label.z_index = 4096
	
	if FONT:
		label.add_theme_font_override("font", FONT)
		
	# Slightly larger floating text for satellite popups
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_outline_color", Color(0.1, 0.1, 0.1, 1.0))
	label.add_theme_constant_override("outline_size", 8)
	
	var parent_node: Node = get_parent() if get_parent() != null else self
	parent_node.add_child(label)
	
	label.top_level = true
	label.pivot_offset = label.get_minimum_size() / 2.0
	label.global_position = global_pos - (label.get_minimum_size() / 2.0) + Vector2(randf_range(-10, 10), randf_range(-10, 10))
	
	var tween := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS).set_parallel(true)
	
	tween.tween_property(label, "global_position:y", label.global_position.y - 60.0, 0.65)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
		
	label.scale = Vector2(0.4, 0.4)
	tween.tween_property(label, "scale", Vector2(1.4, 1.4), 0.12)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	tween.chain().tween_property(label, "scale", Vector2.ZERO, 0.35)\
		.set_delay(0.18)\
		.set_trans(Tween.TRANS_QUAD)
		
	tween.chain().finished.connect(label.queue_free)


func spawn_center_floating_text(text_value: String, color: Color) -> void:
	var label := Label.new()
	label.text = text_value
	label.z_index = 4096
	
	if FONT:
		label.add_theme_font_override("font", FONT)
		
	# Slightly larger floating text for center announcements
	label.add_theme_font_size_override("font_size", 42)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_outline_color", Color(0.05, 0.05, 0.05, 1.0))
	label.add_theme_constant_override("outline_size", 12)
	
	var parent_node: Node = get_parent() if get_parent() != null else self
	parent_node.add_child(label)
	
	label.top_level = true
	
	var viewport_center := get_viewport_rect().size / 2.0
	var label_size := label.get_minimum_size()
	
	label.pivot_offset = label_size / 2.0
	label.global_position = viewport_center - (label_size / 2.0)
	
	var tween := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS).set_parallel(true)
	
	tween.tween_property(label, "global_position:y", label.global_position.y - 70.0, 0.75)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
		
	label.scale = Vector2(0.5, 0.5)
	tween.tween_property(label, "scale", Vector2(1.3, 1.3), 0.15)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	tween.chain().tween_property(label, "scale", Vector2.ZERO, 0.4)\
		.set_delay(0.2)\
		.set_trans(Tween.TRANS_QUAD)
		
	tween.chain().finished.connect(label.queue_free)
