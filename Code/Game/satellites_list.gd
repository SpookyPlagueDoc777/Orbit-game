extends Node2D

const POWER_SATELLITE = preload("uid://bvkw14d2odqso")
const SHIELD_SATELLITE = preload("uid://kybt02uh27cp")
const SPIN_SATELLITE = preload("uid://dlbawowx6xel6")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func launch_satellite(satellitetype: int) -> void:
	var thesatellite
	match satellitetype:
		0:
			thesatellite = POWER_SATELLITE.instantiate()
		1:
			thesatellite = SHIELD_SATELLITE.instantiate()
		2:
			thesatellite = SPIN_SATELLITE.instantiate()
	if Global.energy >= thesatellite.satenergylaunch:
		print(Global.energy)
		print(thesatellite.satenergylaunch)
		add_child(thesatellite)
		Global.energy -= thesatellite.satenergylaunch
