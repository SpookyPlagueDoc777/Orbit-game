extends Satellite

func _init() -> void:
	satellitename = "Shield Satellite"
	satellitetype = "Shield"
	health = 20.0
	max_health = 20.0
	facesplanet = false
	satenergyprod = 0
	satenergylaunch = 700
	satspinprod = 0.0

func _ready() -> void:
	if launchanimation:
		orbitradius = float(randi_range(250, 500))
	super._ready()

func _physics_process(delta: float) -> void:
	update_position(delta)
	
	second_timer += delta
	update_spin(delta)
	if second_timer >= 1.0:
		second_timer -= 1.0
		update_energy()
