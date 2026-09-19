extends Satellite

func _init() -> void:
	satellitename = "Power Satellite"
	satellitetype = "Power"
	health = 2.0
	max_health = 2.0
	facesplanet = false
	satenergyprod = 2
	satenergylaunch = 100
	satspinprod = 0.0

func _ready() -> void:
	if launchanimation:
		orbitradius = float(randi_range(110, 249))
	super._ready()

func _physics_process(delta: float) -> void:
	update_position(delta)
	satenergyprod = 2 * (upgrade + 1)
	if !Global.is_paused:
		second_timer += delta
	update_spin(delta)
	if second_timer >= 1.0:
		second_timer -= 1.0
		update_energy()
		update_hp()
