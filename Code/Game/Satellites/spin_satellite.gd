extends satellite


func _ready() -> void:
	## Satellite info
	satellitename = "Spin Satellite"
	health = 5
	facesplanet = false
	orbitradius = 400
	
	## Satellite stats
	satenergyprod = 0
	satenergylaunch = 500
	satspinprod = 0.0005
	
func _process(delta: float) -> void:
	pass
