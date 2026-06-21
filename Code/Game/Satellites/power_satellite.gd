extends satellite


func _ready() -> void:
	## Satellite info
	satellitename = "Power Satellite"
	health = 2
	facesplanet = false
	orbitradius = 400
	
	## Satellite stats
	satenergyprod = 5
	satenergylaunch = 100
	satspinprod = 0
	
func _process(delta: float) -> void:
	pass
