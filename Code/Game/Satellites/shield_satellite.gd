extends satellite


func _ready() -> void:
	## Satellite info
	satellitename = "Shield Satellite"
	health = 20
	facesplanet = false
	orbitradius = 200
	
	## Satellite stats
	satenergyprod = 0
	satenergylaunch = 600
	satspinprod = 0
	
	launch()
	
func _process(delta: float) -> void:
	update_position()
