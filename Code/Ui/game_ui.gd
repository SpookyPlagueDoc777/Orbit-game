extends Control

const SATELLITE_INFO = preload("uid://bb15mu16gd08i")

var last_state: bool
@onready var shop_menu: Control = $Shop_ui/ShopMenu
@onready var pause_button: Button = $PauseButton/PauseButton
@onready var satellite_container: VBoxContainer = $SatelliteList/VBoxContainer/SatelliteScroll/SatelliteContainer
@onready var satellite_container2: VBoxContainer = $Shop_ui/ShopMenu/ActualButtons/SatellitesList/VBoxContainer/SatelliteScroll/SatelliteContainer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and visible == false:
		update_satellite_list()
		visible = true
		shop_menu.visible = false
		Global.is_paused = last_state
		pause_button.button_pressed = !last_state

func _on_button_pressed() -> void:
	update_satellite_list()
	visible = false
	shop_menu.visible = true
	last_state = Global.is_paused
	Global.is_paused = true


func _on_back_button_pressed() -> void:
	if visible == false:
		update_satellite_list()
		visible = true
		shop_menu.visible = false
		Global.is_paused = last_state
		pause_button.button_pressed = !last_state

func update_satellite_list() -> void:
	var satellites: Array = get_tree().get_nodes_in_group("SatelliteGroup")
	for member in satellite_container.get_children():
		member.queue_free()
	for member in satellites:
		var satelitus = SATELLITE_INFO.instantiate()
		satellite_container.add_child(satelitus)
		satelitus.update_info(member)
<<<<<<< Updated upstream
=======
		
	
	for member in satellite_container2.get_children():
		member.queue_free()
	for member in satellites:
		var satelitus2 = SATELLITE_INFO.instantiate()
		satellite_container2.add_child(satelitus2)
		satelitus2.update_info(member)
		
	print(satellites)
>>>>>>> Stashed changes
