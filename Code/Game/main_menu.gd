extends Node2D


func _ready() -> void:
	if OS.has_method("web"):
		$Spaceeee/Button2.hide()



func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game/main_node.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
