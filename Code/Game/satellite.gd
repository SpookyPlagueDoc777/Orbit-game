class_name Satellite
extends CharacterBody2D

const HALF_PI := PI / 2.0
const FONT = preload("uid://dr3nm75s2psu5")

@export_category("Satellite Stats")
@export var satellitename: String = "Satellite"
@export var satellitetype: String = "Base"
@export var health: float = 10.0
@export var max_health: float = 10.0
@export var orbitradius: float = 150.0
@export var facesplanet: bool = false

@export_category("Flash Effect Colors")
@export var damage_flash_color: Color = Color(1.0, 0.2, 0.2, 1.0)
@export var upgrade_flash_color: Color = Color(2.0, 1.8, 0.3, 1.0)

@export_category("Satellite Energy & Production")
@export var satenergyprod: int = 0
@export var satenergylaunch: int = 100
@export var upgrade: int = 0:
	set(val):
		var old_val := upgrade
		upgrade = val
		if val > old_val and is_inside_tree():
			play_upgrade_animation()
			spawn_satellite_floating_text(get_clean_display_name() + " +1", upgrade_flash_color)

@export var satspinprod: float = 0.0

var baseangle: float = PI / 4.0
var orbitspeed: float = 0.0
var launchanimation: bool = false
var inorbit: bool = false
var tween: Tween = null
var second_timer: float = 0.0
var _anim_tween: Tween = null
var _active_label: Label = null

@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null


func _enter_tree() -> void:
	add_to_group("SatelliteGroup")
	if Global.has_signal("satellite_upgraded"):
		if not Global.satellite_upgraded.is_connected(_on_satellite_upgraded):
			Global.satellite_upgraded.connect(_on_satellite_upgraded)


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	position = Vector2(7, -64)
	scale = Vector2.ZERO

func _process(delta: float) -> void:
	if !Global.is_paused && !launchanimation && !inorbit:
		launch()


func get_clean_display_name() -> String:
	var clean_text := ""
	
	if satellitetype != "" and satellitetype != "Base" and not "@" in satellitetype:
		clean_text = satellitetype
	elif satellitename != "" and satellitename != "Satellite" and not "@" in satellitename:
		clean_text = satellitename
	else:
		var raw_node_name := name
		if "@" in raw_node_name:
			var parts := raw_node_name.split("@")
			for part in parts:
				if part != "" and not "CharacterBody" in part and not "Node" in part:
					clean_text = part
					break
		else:
			clean_text = raw_node_name

	clean_text = clean_text.replace("CharacterBody2D", "").replace("Satellite", "").strip_edges()
	
	if clean_text == "" or clean_text.is_valid_int():
		clean_text = "SATELLITE"
		
	return clean_text.to_upper()


func _on_satellite_upgraded(sat_node: Node) -> void:
	if sat_node == self:
		play_upgrade_animation()
		spawn_satellite_floating_text(get_clean_display_name() + " +1", upgrade_flash_color)


func _physics_process(delta: float) -> void:
	update_position(delta)
	update_spin(delta)


func launch() -> void:
	launchanimation = true
	position = Vector2(7, -64)
	scale = Vector2.ZERO
	modulate = Color(1.5, 1.5, 1.5, 1.0)
	
	if Global.planetmass > 0 and Global.G > 0:
		orbitspeed = sqrt(Global.G * Global.planetmass / orbitradius)
	else:
		orbitspeed = 50.0

	var target_pos := Vector2(orbitradius * cos(baseangle), -orbitradius * sin(baseangle))
	var duration := sqrt(orbitradius) * randf_range(0.5, 2.0) / 8.75

	if tween and tween.is_valid():
		tween.kill()

	tween = create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position", target_pos, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2.ONE, min(duration, 0.4))
	tween.tween_property(self, "modulate", Color.WHITE, duration)
	tween.chain().finished.connect(_on_animation_finished)


func update_position(delta: float = 0.0) -> void:
	if delta <= 0.0:
		delta = get_physics_process_delta_time()

	if Global.is_paused:
		return

	if not launchanimation:
		orbit_planet(delta)
		
	spin_satellite()

func update_hp() -> void:
	if health > 0.1:
		health -= 0.005

func orbit_planet(delta: float) -> void:
	if orbitradius <= 0.0:
		return
	baseangle = fmod(baseangle + orbitspeed * delta / orbitradius, TAU)
	position.x = orbitradius * cos(baseangle - HALF_PI)
	position.y = orbitradius * sin(baseangle - HALF_PI)


func spin_satellite() -> void:
	if facesplanet:
		rotation = baseangle + HALF_PI
	else:
		if "planetrotation" in SatelliteManager:
			rotation = -SatelliteManager.planetrotation


func update_spin(delta: float) -> void:
	if Global.is_paused or launchanimation:
		return
	Global.spin_speed += satspinprod * delta


func update_energy() -> void:
	if Global.is_paused or launchanimation:
		return
	Global.energy += satenergyprod * clampf(health/max_health + 0.25, 0, 1)


func take_damage(amount: float) -> void:
	health -= amount
	
	if _anim_tween and _anim_tween.is_valid():
		_anim_tween.kill()

	var target_node: CanvasItem = sprite if sprite else self

	_anim_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_anim_tween.tween_property(target_node, "scale", Vector2(1.2, 0.8), 0.06)
	_anim_tween.tween_property(target_node, "modulate", damage_flash_color, 0.06)
	
	_anim_tween.chain().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_anim_tween.tween_property(target_node, "scale", Vector2.ONE, 0.14)
	_anim_tween.tween_property(target_node, "modulate", Color.WHITE, 0.14)

	if health <= 0.0:
		destroy_satellite()


func destroy_satellite() -> void:
	remove_from_group("SatelliteGroup")
	if Global.has_signal("updatelist"):
		Global.updatelist.emit()
		
	if _anim_tween and _anim_tween.is_valid():
		_anim_tween.kill()

	var target_node: CanvasItem = sprite if sprite else self
	var pop_tween := create_tween().set_parallel(true).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	pop_tween.tween_property(target_node, "scale", Vector2(1.3, 1.3), 0.1)
	pop_tween.tween_property(target_node, "modulate:a", 0.0, 0.15)
	pop_tween.chain().finished.connect(queue_free)


func play_upgrade_animation() -> void:
	if not is_inside_tree():
		return

	if _anim_tween and _anim_tween.is_valid():
		_anim_tween.kill()

	var target_node: CanvasItem = sprite if sprite else self

	_anim_tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS).set_parallel(true)
	_anim_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	_anim_tween.tween_property(target_node, "scale", Vector2(1.35, 1.35), 0.12)
	_anim_tween.tween_property(target_node, "modulate", upgrade_flash_color, 0.12)
	
	_anim_tween.chain().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_anim_tween.tween_property(target_node, "scale", Vector2.ONE, 0.18)
	_anim_tween.tween_property(target_node, "modulate", Color.WHITE, 0.18)


func spawn_satellite_floating_text(txt: String, color: Color) -> void:
	if is_instance_valid(_active_label):
		_active_label.queue_free()

	var label := Label.new()
	_active_label = label
	label.text = txt
	label.z_index = 120
	
	if FONT:
		label.add_theme_font_override("font", FONT)
		
	# Scaled size for 1152x648 resolution
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 4)
	
	get_tree().current_scene.add_child(label)
	
	# Center pivot so it scales from the middle directly over satellite
	label.pivot_offset = label.get_minimum_size() / 2.0
	label.global_position = global_position - (label.get_minimum_size() / 2.0) + Vector2(0, -24)
	
	var text_tween := label.create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS).set_parallel(true)
	
	text_tween.tween_property(label, "global_position:y", label.global_position.y - 25.0, 0.55)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
		
	label.scale = Vector2(0.2, 0.2)
	text_tween.tween_property(label, "scale", Vector2.ONE, 0.12)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	text_tween.chain().tween_property(label, "scale", Vector2.ZERO, 0.25)\
		.set_delay(0.18)\
		.set_trans(Tween.TRANS_QUAD)
		
	text_tween.chain().finished.connect(label.queue_free)


func _on_area_2d_area_entered(_area: Area2D) -> void:
	take_damage(1.0)


func _on_animation_finished() -> void:
	launchanimation = false
	inorbit = true
