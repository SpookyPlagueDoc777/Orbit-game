extends satellite

var second: float = 0
func _ready() -> void:
	## Satellite info(Must match export)
	satellitename = "Power Satellite"
	satellitetype = "Power"
	health = 2
	facesplanet = false
	orbitradius = randi_range(110, 249)
	
	## Satellite stats
	satenergyprod = 2
	satenergylaunch = 100
	satspinprod = 0
	
	launch()
	
func _process(delta: float) -> void:
	update_position()
	satenergyprod = 2 * (upgrade + 1)

func _physics_process(delta: float) -> void:
	second += delta
	update_spin(delta)
	if second > 1:
		second -= 1
		update_energy()
