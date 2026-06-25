extends HBoxContainer

@onready var line_edit: LineEdit = $LineEdit
@onready var sprite: AnimatedSprite2D = $SatelliteSprite

var the_satellite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_info(satellites) -> void:
	match satellites.satellitetype:
		"Spin":
			sprite.animation = "spin_satellite"
		"Shield":
			sprite.animation = "shield_satellite"
		"Power":
			sprite.animation = "power_satellite"
	sprite.play()
	line_edit.text = satellites.satellitename
	the_satellite = satellites


func _on_line_edit_text_changed(new_text: String) -> void:
	the_satellite.satellitename = new_text
