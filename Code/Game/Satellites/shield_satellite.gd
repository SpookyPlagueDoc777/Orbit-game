extends satellite

var second: float = 0
func _ready() -> void:
	## Satellite info(Must match export)
	satellitename = "Shield Satellite"
	satellitetype = "Shield"
	health = 20
	facesplanet = false
	orbitradius = randi_range(250, 500)
	
	## Satellite stats
	satenergyprod = 0
	satenergylaunch = 700
	satspinprod = 0
	
	launch()
	
func _process(delta: float) -> void:
	update_position()

func _physics_process(delta: float) -> void:
	second += delta
	update_spin(delta)
	if second > 1:
		second -= 1
		update_energy()
