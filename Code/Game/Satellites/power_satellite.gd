extends Satellite

<<<<<<< Updated upstream

func _ready() -> void:
	## Satellite info
	satellitename = "Power Satellite"
	health = 2
	facesplanet = false
	orbitradius = 150
	
	## Satellite stats
	satenergyprod = 5
	satenergylaunch = 100
	satspinprod = 0
	
	launch()
	
func _process(_delta: float) -> void:
	update_position()


func _on_area_2d_area_entered(area: Area2D) -> void:
	register_hit(area)
=======
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
	super._ready()
	if launchanimation:
		orbitradius = randi_range(110, 249)
		launch()

func _process(delta: float) -> void:
	update_position()
	satenergyprod = 2 * (upgrade + 1)
	
	second_timer += delta
	update_spin(delta)
	if second_timer >= 1.0:
		second_timer -= 1.0
		update_energy()
>>>>>>> Stashed changes
