extends CharacterBody2D

class_name satellite

@export_category("Satellite Stats")
@export var satellitename: String
@export var health: float
@export var orbitradius: float
@export var baseangle: float

@export_category("Satellite Energy")
@export var satenergyprod: int
@export var satenergylaunch: int
@export var satspinprod: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	orbit_planet()

func orbit_planet() -> void:
	var orbitspeed: float = sqrt(Global.G * Global.planetmass / orbitradius)
	baseangle = fmod(baseangle + orbitspeed * get_process_delta_time() / orbitradius, (2 * PI))
	var x_pos: float = cos(baseangle)
	var y_pos: float = sin(baseangle)
	
	position.x = orbitradius * x_pos
	position.y = orbitradius * y_pos


func _on_area_2d_area_entered(area: Area2D) -> void:
	health -= 1
	if health <= 0:
		get_tree().queue_delete($".")
