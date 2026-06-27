extends Control

const SATELLITE_INFO = preload("uid://bb15mu16gd08i")

var last_state: bool
@onready var shop_menu: Control = $Shop_ui/ShopMenu
@onready var pause_button: Button = $PauseButton/PauseButton
@onready var satellite_container: VBoxContainer = $SatelliteList/VBoxContainer/SatelliteScroll/SatelliteContainer
@onready var satellite_container2: VBoxContainer = $Shop_ui/ShopMenu/ActualButtons/SatellitesList/VBoxContainer/SatelliteScroll/SatelliteContainer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and visible == false:
		#If satellite destruction is added
		#update_satellite_list_main()
		Global.updatelist.emit()
		visible = true
		shop_menu.visible = false
		Global.is_paused = last_state
		pause_button.button_pressed = !last_state

func _on_button_pressed() -> void:
	#If satellite destruction is added
	#update_satellite_list_shop()
	Global.updatelist.emit()
	SoundManager.successful_push()
	visible = false
	shop_menu.visible = true
	last_state = Global.is_paused
	Global.is_paused = true


func _on_back_button_pressed() -> void:
	if visible == false:
		SoundManager.successful_push()
		#If satellite destruction is added
		#update_satellite_list_main()
		Global.updatelist.emit()
		visible = true
		shop_menu.visible = false
		Global.is_paused = last_state
		pause_button.button_pressed = !last_state

func update_satellite_list_main() -> void:
	var satellites: Array = get_tree().get_nodes_in_group("SatelliteGroup")
	for member in satellite_container.get_children():
		member.queue_free()
	for member in satellites:
		var satelitus = SATELLITE_INFO.instantiate()
		satellite_container.add_child(satelitus)
		satelitus.update_info(member)
		

func update_satellite_list_shop() -> void:
	var satellites: Array = get_tree().get_nodes_in_group("SatelliteGroup")
		
	
	for member in satellite_container2.get_children():
		member.queue_free()
	for member in satellites:
		var satelitus2 = SATELLITE_INFO.instantiate()
		satellite_container2.add_child(satelitus2)
		satelitus2.update_info(member)

func add_to_shop(satelitite: Node) -> void:
	var satelitus = SATELLITE_INFO.instantiate()
	satellite_container2.add_child(satelitus)
	satelitus.update_info(satelitite)

func add_to_main(satelitite: Node) -> void:
	var satelitus = SATELLITE_INFO.instantiate()
	satellite_container.add_child(satelitus)
	satelitus.update_info(satelitite)

func _on_buy_energy_satellite_pressed() -> void:
	var satinfo: Node
	satinfo = SatelliteManager.launch_satellite(0)
	print(satinfo)
	if satinfo != null:
		add_to_shop(satinfo)
		add_to_main(satinfo)


func _on_buy_spin_satellite_pressed() -> void:
	var satinfo: Node
	satinfo = SatelliteManager.launch_satellite(2)
	if satinfo != null:
		add_to_shop(satinfo)
		add_to_main(satinfo)


func _on_buy_shield_satellite_pressed() -> void:
	var satinfo: Node
	satinfo = SatelliteManager.launch_satellite(1)
	if satinfo != null:
		add_to_shop(satinfo)
		add_to_main(satinfo)
