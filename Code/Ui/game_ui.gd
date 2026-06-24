extends Control
@onready var shop_menu: Control = $Shop_ui/ShopMenu

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and visible == false:
		visible = true
		shop_menu.visible = false

func _on_button_pressed() -> void:
	visible = false
	shop_menu.visible = true
