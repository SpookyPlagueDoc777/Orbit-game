extends Button


@onready var rich_label: RichTextLabel = $RichTextLabel
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D


var base_position: Vector2

func _ready() -> void:

	rich_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	

	rich_label.pivot_offset = rich_label.size / 2
	base_position = rich_label.position
	

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)


func _on_mouse_entered() -> void:
	audio.play()
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	

	tween.tween_property(rich_label, "position", base_position + Vector2(0, -6), 0.2)
	tween.tween_property(rich_label, "scale", Vector2(1.1, 1.1), 0.2)
	tween.tween_property(rich_label, "modulate", Color("caf061"), 0.2)


func _on_mouse_exited() -> void:
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	# Return back to baseline positions smoothly
	tween.tween_property(rich_label, "position", base_position, 0.2)
	tween.tween_property(rich_label, "scale", Vector2.ONE, 0.2)
	tween.tween_property(rich_label, "modulate", Color.WHITE, 0.2)


func _on_button_down() -> void:
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(rich_label, "scale", Vector2(0.95, 0.95), 0.05)
