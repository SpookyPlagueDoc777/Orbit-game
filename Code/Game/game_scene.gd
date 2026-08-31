extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var planet: Node2D = $Planet
@onready var shop_menu: Control = $"../CanvasLayer/GameUI/Shop_ui/ShopMenu"

var panning: bool = false
var zoomscale: float = 1.0
var in_menu: bool = false

var _target_zoom: Vector2 = Vector2.ONE
var _target_pos: Vector2 = Vector2.ZERO
var _zoom_tween: Tween
var _pan_tween: Tween

func _ready() -> void:
	_target_zoom = camera.zoom
	_target_pos = camera.position

func _physics_process(delta: float) -> void:
	if not Global.is_paused:
		planet.rotation += Global.spin_speed * delta
		if "planetrotation" in SatelliteManager:
			SatelliteManager.planetrotation = planet.rotation

func _input(event: InputEvent) -> void:
	if is_instance_valid(shop_menu) and shop_menu.visible:
		return

	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		in_menu = mouse_event.position.y > 510.0

		if mouse_event.is_pressed():
			if mouse_event.button_index == MOUSE_BUTTON_WHEEL_UP and not in_menu:
				_smooth_zoom(1.25)
			elif mouse_event.button_index == MOUSE_BUTTON_WHEEL_DOWN and not in_menu:
				_smooth_zoom(0.8)
			elif mouse_event.button_index == MOUSE_BUTTON_MIDDLE:
				panning = true
		elif mouse_event.is_released():
			if mouse_event.button_index == MOUSE_BUTTON_MIDDLE:
				panning = false

	elif event is InputEventMouseMotion and panning:
		var motion_event := event as InputEventMouseMotion
		_target_pos -= motion_event.relative / camera.zoom
		_clamp_target_position()
		
		if _pan_tween and _pan_tween.is_running():
			_pan_tween.kill()
			
		_pan_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		_pan_tween.tween_property(camera, "position", _target_pos, 0.1)

func _smooth_zoom(zoom_factor: float) -> void:
	var mouse_world_before := camera.get_global_mouse_position()
	
	_target_zoom *= zoom_factor
	_target_zoom.x = clamp(_target_zoom.x, 0.05, 10.0)
	_target_zoom.y = clamp(_target_zoom.y, 0.05, 10.0)
	
	if _zoom_tween and _zoom_tween.is_running():
		_zoom_tween.kill()

	_zoom_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_zoom_tween.tween_property(camera, "zoom", _target_zoom, 0.25)
	
	var mouse_world_after := camera.get_global_mouse_position()
	_target_pos += (mouse_world_before - mouse_world_after)
	_clamp_target_position()
	_zoom_tween.tween_property(camera, "position", _target_pos, 0.25)

func _clamp_target_position() -> void:
	_target_pos.x = clamp(_target_pos.x, -32000.0, 32000.0)
	_target_pos.y = clamp(_target_pos.y, -18000.0, 18000.0)
