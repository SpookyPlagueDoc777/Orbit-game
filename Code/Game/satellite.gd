class_name Satellite
extends CharacterBody2D

@export_category("Satellite Stats")
<<<<<<< Updated upstream
@export var satellitename: String
@export var health: float
@export var orbitradius: float
@export var facesplanet: bool
var baseangle: float = PI/4

@export_category("Satellite Energy")
@export var satenergyprod: int
@export var satenergylaunch: int
@export var satspinprod: float
var orbitspeed: float
var launchanimation: bool = true
# Called when the node enters the scene tree for the first time.
=======
@export var satellitename: String = "Satellite"
@export var satellitetype: String = "Base"
@export var health: float = 10.0
@export var max_health: float = 10.0
@export var orbitradius: float = 150.0
@export var facesplanet: bool = false
var baseangle: float = PI / 4

@export_category("Satellite Energy & Production")
@export var satenergyprod: int = 0
@export var satenergylaunch: int = 100
@export var upgrade: int = 0
@export var satspinprod: float = 0.0

var orbitspeed: float = 0.0
var launchanimation: bool = true
var tween: Tween = null
var second_timer: float = 0.0
var satellites: Node2D = null
var planetrotation: float = 0.0 # Make sure this variable exists!

func _ready() -> void:
	add_to_group("SatelliteGroup")
>>>>>>> Stashed changes

func orbit_planet() -> void:
	if orbitradius <= 0.0:
		return
	baseangle = fmod(baseangle + orbitspeed * get_process_delta_time() / orbitradius, TAU)
	position.x = orbitradius * cos(baseangle - HALF_PI)
	position.y = orbitradius * sin(baseangle - HALF_PI)

func launch() -> void:
<<<<<<< Updated upstream
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	$".".position = Vector2(7, -64)
	orbitspeed = sqrt(Global.G * Global.planetmass / orbitradius)
	tween.tween_property($".","position", Vector2(orbitradius * cos(baseangle), -orbitradius * sin(baseangle)), sqrt(orbitradius)/5)
	tween.emit_signal("finished")
	tween.connect("finished", _on_animation_finished)

func update_position() -> void:
	if !launchanimation:
=======
	position = Vector2(7, -64)
	if Global.planetmass > 0 and Global.G > 0:
		orbitspeed = sqrt(Global.G * Global.planetmass / orbitradius)
	else:
		orbitspeed = 50.0

	var target_pos := Vector2(orbitradius * cos(baseangle), -orbitradius * sin(baseangle))
	var duration := sqrt(orbitradius) * randf_range(0.5, 2.0) / 8.75

	if tween and tween.is_valid():
		tween.kill()

	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", target_pos, duration)
	tween.finished.connect(_on_animation_finished)

func update_position() -> void:
	if Global.is_paused:
		if tween and tween.is_valid() and tween.is_running():
			tween.pause()
		return

	if tween and tween.is_valid() and not tween.is_running() and launchanimation:
		tween.play()

	if not launchanimation:
>>>>>>> Stashed changes
		orbit_planet()
	if facesplanet:
		spin_satellite()

func spin_satellite() -> void:
<<<<<<< Updated upstream
	rotation = baseangle + (PI/2)

func register_hit(_area: Area2D) -> void:
	print("oo")
	health -= 1
=======
	if facesplanet:
		rotation = baseangle + HALF_PI
	else:
		if "planetrotation" in SatelliteManager:
			rotation = -SatelliteManager.planetrotation

func _on_area_2d_area_entered(_area: Area2D) -> void:
	take_damage(1.0)

func take_damage(amount: float) -> void:
	health -= amount
>>>>>>> Stashed changes
	if health <= 0:
		destroy_satellite()

func destroy_satellite() -> void:
	if Global.has_signal("updatelist"):
		Global.updatelist.emit()
	queue_free()

func _on_animation_finished() -> void:
	launchanimation = false
<<<<<<< Updated upstream
=======

func update_spin(delta: float) -> void:
	if Global.is_paused or launchanimation:
		return
	Global.spin_speed += satspinprod * delta

func update_energy() -> void:
	if Global.is_paused or launchanimation:
		return
	Global.energy += satenergyprod

const HALF_PI := PI / 2.0
>>>>>>> Stashed changes
