extends CharacterBody2D

class_name satellite

@export_category("Satellite Stats")
@export var satellitename: String
@export var health: float
@export var orbitradius: float
var baseangle: float = PI/4

@export_category("Satellite Energy")
@export var satenergyprod: int
@export var satenergylaunch: int
@export var satspinprod: float
var orbitspeed: float
var launchanimation: bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	$".".position = Vector2(50, -260)
	print(position)
	orbitspeed = sqrt(Global.G * Global.planetmass / orbitradius)
	print(Vector2(orbitradius/cos(baseangle), -orbitradius/sin(baseangle)))
	tween.tween_property($".","position", Vector2(orbitradius * cos(baseangle), -orbitradius * sin(baseangle)), sqrt(orbitradius)/10)
	tween.emit_signal("finished")
	tween.connect("finished", _on_animation_finished)
	print(baseangle)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if launchanimation == false:
		orbit_planet()

func orbit_planet() -> void:
	baseangle = fmod(baseangle + orbitspeed * get_process_delta_time() / orbitradius, (2 * PI))
	
	position.x = orbitradius * cos(baseangle - PI/2)
	position.y = orbitradius * sin(baseangle - PI/2)


func _on_area_2d_area_entered(area: Area2D) -> void:
	health -= 1
	if health <= 0:
		get_tree().queue_delete($".")

func _on_animation_finished() -> void:
	launchanimation = false
