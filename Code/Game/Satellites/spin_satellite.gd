extends satellite


func _ready() -> void:
	## Satellite info
	satellitename = "Spin Satellite"
	health = 5
	facesplanet = true
	orbitradius = 150
	
	## Satellite stats
	satenergyprod = 0
	satenergylaunch = 400
	satspinprod = 0.0005
	
	launch()
	
func _process(delta: float) -> void:
	update_position()
