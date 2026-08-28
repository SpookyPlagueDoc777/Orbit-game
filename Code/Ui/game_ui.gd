extends Control
<<<<<<< Updated upstream
@onready var shop_menu: Control = $Shop_ui/ShopMenu

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and visible == false:
		visible = true
		shop_menu.visible = false

func _on_button_pressed() -> void:
	visible = false
	shop_menu.visible = true


func _on_save_button_pressed() -> void:
	get_parent().get_parent().save()




func show_save_notification() -> void:
	var label := $SaveNotification
=======

const SATELLITE_ITEM_SCENE = preload("uid://bb15mu16gd08i")

var last_state: bool

@onready var shop_menu: Control = $Shop_ui/ShopMenu
@onready var pause_button: Button = $PauseButton/PauseButton
@onready var satellite_container: VBoxContainer = $SatelliteList/VBoxContainer/SatelliteScroll/SatelliteContainer
@onready var satellite_container2: VBoxContainer = $Shop_ui/ShopMenu/ActualButtons/SatellitesList/VBoxContainer/SatelliteScroll/SatelliteContainer
@onready var upgrade_all_button: Button = $Shop_ui/ShopMenu/ActualButtons/UpgradeAll/UpgradeAllButton
@onready var save_button: Button = $save/PauseButton

func _ready() -> void:
	if Global.has_signal("updatelist"):
		Global.updatelist.connect(rebuild_all_satellite_lists)
	
	if SaveManager.has_signal("load_completed"):
		SaveManager.load_completed.connect(_on_save_load_completed)
		
	# Instantly rebuild list on startup frame
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
	last_state = Global.is_paused
	Global.is_paused = true
	rebuild_all_satellite_lists()

func _on_back_button_pressed() -> void:
	if not visible:
		SoundManager.successful_push()
		_close_shop()

func _close_shop() -> void:
	visible = true
	shop_menu.visible = false
	Global.is_paused = last_state
	pause_button.button_pressed = not last_state
	rebuild_all_satellite_lists()

func rebuild_all_satellite_lists() -> void:
	Global.upgrade_all = 0
	_clear_container(satellite_container)
	_clear_container(satellite_container2)

	var satellites: Array = get_tree().get_nodes_in_group("SatelliteGroup")
	for sat in satellites:
		if is_instance_valid(sat):
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
	if item_row.has_method("setup_info"):
		item_row.setup_info(sat_node, false)
	elif item_row.has_method("update_info"):
		item_row.update_info(sat_node, false)

func _on_buy_energy_satellite_pressed() -> void:
	_attempt_launch(0)

func _on_buy_spin_satellite_pressed() -> void:
	_attempt_launch(2)

func _on_buy_shield_satellite_pressed() -> void:
	_attempt_launch(1)

func _attempt_launch(type_id: int) -> void:
	var launched_sat: Node = SatelliteManager.launch_satellite(type_id)
	if launched_sat != null:
		rebuild_all_satellite_lists()

func _on_upgrade_all_button_pressed() -> void:
	if Global.energy >= Global.upgrade_all and Global.upgrade_all > 0:
		SoundManager.successful_push()
		Global.energy -= Global.upgrade_all
		var satellites: Array = get_tree().get_nodes_in_group("SatelliteGroup")
		for sat in satellites:
			if is_instance_valid(sat):
				sat.upgrade += 1
		rebuild_all_satellite_lists()
	else:
		SoundManager.unsuccessful_push()

func _on_pause_button_pressed() -> void:
	SaveManager.save_game()
	show_save_notification()

func show_save_notification() -> void:
	var label: Label = get_node_or_null("SaveNotification")
	if not label:
		return

>>>>>>> Stashed changes
	label.modulate.a = 0.0
	label.scale = Vector2(0.8, 0.8)

	var tween := create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.25)
<<<<<<< Updated upstream
	tween.parallel().tween_property(label, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)  # little pop
	tween.tween_interval(1.0)
	tween.tween_property(label, "modulate:a", 0.0, 0.5) 
=======
	tween.parallel().tween_property(label, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_interval(1.0)
	tween.tween_property(label, "modulate:a", 0.0, 0.5)
>>>>>>> Stashed changes
