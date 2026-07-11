extends Control
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
	label.modulate.a = 0.0
	label.scale = Vector2(0.8, 0.8)

	var tween := create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.25)
	tween.parallel().tween_property(label, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)  # little pop
	tween.tween_interval(1.0)
	tween.tween_property(label, "modulate:a", 0.0, 0.5) 
