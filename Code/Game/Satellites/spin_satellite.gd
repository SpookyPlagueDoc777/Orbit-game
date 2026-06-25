extends satellite

var second: float = 0
func _ready() -> void:
	## Satellite info(Must match export)
	satellitename = "Spin Satellite"
	satellitetype = "Spin"
	health = 5
	facesplanet = true
	orbitradius = 150
	
	## Satellite stats
	satenergyprod = 0
	satenergylaunch = 400
	satspinprod = 0.00001
	
	launch()
	
func _process(delta: float) -> void:
	update_position()

func _physics_process(delta: float) -> void:
	second += delta
	update_spin(delta)
	if second > 1:
		second -= 1
		update_energy()
		
