extends Sprite2D


@export var float_amplitude: float = 10.0
@export var float_speed: float = 1.0

# Store the starting Y positions
@onready var start_y: float = position.y

func _process(_delta: float) -> void:

	var offset: float = sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_amplitude
	
	# Apply the offset to the starting position
	position.y = start_y + offset
