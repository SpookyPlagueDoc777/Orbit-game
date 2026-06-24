extends satellite


func _ready() -> void:
	## Satellite info
	satellitename = "Spin Satellite"
	health = 5
	facesplanet = false
	orbitradius = 150
	
	## Satellite stats
	satenergyprod = 0
	satenergylaunch = 500
	satspinprod = 0.0005
	
	launch()
	
func _process(delta: float) -> void:
	update_position()
