extends satellite


func _ready() -> void:
	## Satellite info
	satellitename = "Shield Satellite"
	health = 20
	facesplanet = false
	orbitradius = 400
	
	## Satellite stats
	satenergyprod = 0
	satenergylaunch = 600
	satspinprod = 0
	
	
func _process(delta: float) -> void:
	pass
