extends CharacterBody2D

class_name satellite

@export_category("Satellite Stats")
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

func orbit_planet() -> void:
	baseangle = fmod(baseangle + orbitspeed * get_process_delta_time() / orbitradius, (2 * PI))
	
	position.x = orbitradius * cos(baseangle - PI/2)
	position.y = orbitradius * sin(baseangle - PI/2)

func launch() -> void:
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
		orbit_planet()
	if facesplanet:
		spin_satellite()

func spin_satellite() -> void:
	rotation = baseangle + (PI/2)

func register_hit(area: Area2D) -> void:
	print("oo")
	health -= 1
	if health <= 0:
		get_tree().queue_delete($".")

func _on_animation_finished() -> void:
	launchanimation = false
