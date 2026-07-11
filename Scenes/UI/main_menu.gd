extends Node2D

func _ready() -> void:
	if OS.has_method("web"):
		$Spaceeee/quit.hide()




func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game/main_node.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
