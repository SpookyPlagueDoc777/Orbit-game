extends Node2D

const POWER_SATELLITE = preload("uid://bvkw14d2odqso")
const SHIELD_SATELLITE = preload("uid://kybt02uh27cp")
const SPIN_SATELLITE = preload("uid://dlbawowx6xel6")

var satellites_container: Node2D = null

func _ready() -> void:
	_find_container()

func _find_container() -> void:
	if not is_instance_valid(satellites_container):
		satellites_container = get_tree().get_first_node_in_group("satellites_container") as Node2D

func launch_satellite(satellitetype: int) -> Satellite:
	_find_container()
	if not is_instance_valid(satellites_container):
		push_error("SatelliteFactory Error: No satellites_container group node found!")
		return null

	var sat: Satellite = null
	match satellitetype:
		0:
			sat = POWER_SATELLITE.instantiate() as Satellite
		1:
			sat = SHIELD_SATELLITE.instantiate() as Satellite
		2:
			sat = SPIN_SATELLITE.instantiate() as Satellite

	if sat == null:
		return null

	if Global.energy >= sat.satenergylaunch:
		SoundManager.successful_push()
		Global.energy -= sat.satenergylaunch
		satellites_container.add_child(sat)
		
		if Global.has_signal("updatelist"):
			Global.updatelist.emit()
		return sat
	else:
		sat.free()
		SoundManager.unsuccessful_push()
		return null
