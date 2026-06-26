extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var planet: Node2D = $Planet
@onready var shop_menu: Control = $"../CanvasLayer/GameUI/Shop_ui/ShopMenu"

var panning: bool = false
var panoffset: Vector2
var camerapos: Vector2
var zoomscale: float
var in_menu: bool
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if !Global.is_paused:
		planet.rotation += Global.spin_speed * delta
		SatelliteManager.planetrotation = planet.rotation

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && !shop_menu.visible:
		if get_viewport().get_mouse_position().y > 510:
			in_menu = true
		else:
			in_menu = false
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP && !in_menu:
				zoomscale = 1.5
				zoom_at(zoomscale)
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN && !in_menu:
				zoomscale = 0.6666666666666667
				zoom_at(zoomscale)
			if event.button_index == MOUSE_BUTTON_MIDDLE:
				panoffset = camera.get_local_mouse_position()
				camerapos = camera.get_screen_center_position()
				panning = true
		elif event.is_released():
			if event.button_index == MOUSE_BUTTON_MIDDLE:
				panning = false
	if event is InputEventMouseMotion && panning:
		camera.position = camerapos - (camera.get_local_mouse_position() - panoffset)
		camera.position.x = clamp(camera.position.x, -32000, 32000)
		camera.position.y = clamp(camera.position.y, -17000, 17000)

func zoom_at(zoom_scale: float):
	var oldglobal = camera.get_global_mouse_position()
	camera.zoom *= Vector2(zoom_scale, zoom_scale)
	camera.zoom.x = clamp(camera.zoom.x, 0.01734152992, 25.62890625)
	camera.zoom.y = clamp(camera.zoom.y, 0.01734152992, 25.62890625)
	camera.position -= camera.get_global_mouse_position()-oldglobal
	camera.position.x = clamp(camera.position.x, -32000, 32000)
	camera.position.y = clamp(camera.position.y, -18000, 18000)
