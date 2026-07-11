extends Button


const COLOR_HOVER: Color = Color("caf061")
const COLOR_NORMAL: Color = Color.WHITE

func _on_mouse_entered() -> void:
	modulate = COLOR_HOVER

func _on_mouse_exited() -> void:
	modulate = COLOR_NORMAL
