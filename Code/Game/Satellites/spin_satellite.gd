extends Satellite

<<<<<<< Updated upstream

func _ready() -> void:
	## Satellite info
	satellitename = "Spin Satellite"
	health = 5
=======
func _init() -> void:
	satellitename = "Spin Satellite"
	satellitetype = "Spin"
	health = 5.0
	max_health = 5.0
>>>>>>> Stashed changes
	facesplanet = true
	satenergyprod = 0
<<<<<<< Updated upstream
	satenergylaunch = 500
	satspinprod = 0.0005
	
	launch()
	
func _process(_delta: float) -> void:
	update_position()


func _on_area_2d_area_entered(area: Area2D) -> void:
	register_hit(area)
=======
	satenergylaunch = 400
	satspinprod = 0.00001

func _ready() -> void:
	super._ready()
	if launchanimation:
		orbitradius = 100.0
		launch()

func _process(delta: float) -> void:
	update_position()
	satspinprod = 0.00001 * (upgrade + 1)
	
	second_timer += delta
	update_spin(delta)
	if second_timer >= 1.0:
		second_timer -= 1.0
		update_energy()
>>>>>>> Stashed changes
