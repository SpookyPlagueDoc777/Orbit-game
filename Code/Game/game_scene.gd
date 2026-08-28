extends Node2D

@onready var camera: Camera2D = $Camera2D

var panning: bool = false
var zoomscale: float
<<<<<<< Updated upstream
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoomscale = 1.5
				zoom_at(zoomscale)
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
=======
var in_menu: bool

func _physics_process(delta: float) -> void:
	if not Global.is_paused:
		planet.rotation += Global.spin_speed * delta
		if "planetrotation" in SatelliteManager:
			SatelliteManager.planetrotation = planet.rotation

func _input(event: InputEvent) -> void:
	# Block interaction if the shop menu is open
	if is_instance_valid(shop_menu) and shop_menu.visible:
		return

	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		
		in_menu = mouse_event.position.y > 510.0

		if mouse_event.is_pressed():
			if mouse_event.button_index == MOUSE_BUTTON_WHEEL_UP and not in_menu:
				zoomscale = 1.5
				zoom_at(zoomscale)
			elif mouse_event.button_index == MOUSE_BUTTON_WHEEL_DOWN and not in_menu:
>>>>>>> Stashed changes
				zoomscale = 0.6666666666666667
				zoom_at(zoomscale)
			elif mouse_event.button_index == MOUSE_BUTTON_MIDDLE:
				panning = true
		elif mouse_event.is_released():
			if mouse_event.button_index == MOUSE_BUTTON_MIDDLE:
				panning = false

	elif event is InputEventMouseMotion and panning:
		var motion_event := event as InputEventMouseMotion
		# Moves the camera opposite to mouse motion scaled by camera zoom (Editor style)
		camera.position -= motion_event.relative / camera.zoom
		_clamp_camera_position()

func zoom_at(zoom_scale: float) -> void:
	var oldglobal := camera.get_global_mouse_position()
	camera.zoom *= Vector2(zoom_scale, zoom_scale)
	camera.zoom.x = clamp(camera.zoom.x, 0.01734152992, 25.62890625)
	camera.zoom.y = clamp(camera.zoom.y, 0.01734152992, 25.62890625)
	camera.position -= camera.get_global_mouse_position() - oldglobal
	_clamp_camera_position()

func _clamp_camera_position() -> void:
	camera.position.x = clamp(camera.position.x, -32000.0, 32000.0)
	camera.position.y = clamp(camera.position.y, -18000.0, 18000.0)
