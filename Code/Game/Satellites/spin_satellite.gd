extends Satellite

func _init() -> void:
	satellitename = "Spin Satellite"
	satellitetype = "Spin"
	health = 5.0
	max_health = 5.0
	facesplanet = true
	satenergyprod = 0
	satenergylaunch = 400
	satspinprod = 0.00001

func _ready() -> void:
	if launchanimation:
		orbitradius = 100.0
	super._ready()

func _physics_process(delta: float) -> void:
	update_position(delta)
	satspinprod = 0.00001 * (upgrade + 1)
	
	if !Global.is_paused:
		second_timer += delta
	update_spin(delta)
	if second_timer >= 1.0:
		second_timer -= 1.0
		update_energy()
		update_hp()
