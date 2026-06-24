extends Control

var last_state: bool
@onready var shop_menu: Control = $Shop_ui/ShopMenu
@onready var pause_button: Button = $PauseButton/PauseButton

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and visible == false:
		visible = true
		shop_menu.visible = false
		Global.is_paused = last_state
		pause_button.button_pressed = !last_state

func _on_button_pressed() -> void:
	visible = false
	shop_menu.visible = true
	last_state = Global.is_paused
	Global.is_paused = true


func _on_back_button_pressed() -> void:
	if visible == false:
		visible = true
		shop_menu.visible = false
		Global.is_paused = last_state
		pause_button.button_pressed = !last_state
