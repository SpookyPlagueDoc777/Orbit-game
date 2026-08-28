extends Satellite

<<<<<<< Updated upstream

func _ready() -> void:
	## Satellite info
	satellitename = "Shield Satellite"
	health = 20
	facesplanet = false
	orbitradius = 200
	
	## Satellite stats
	satenergyprod = 0
	satenergylaunch = 600
	satspinprod = 0
	
	launch()
	
func _process(_delta: float) -> void:
	update_position()


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("leftd")
	register_hit(area)
=======
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
	super._ready()
	if launchanimation:
		orbitradius = randi_range(250, 500)
		launch()

func _process(delta: float) -> void:
	update_position()
	second_timer += delta
	update_spin(delta)
	if second_timer >= 1.0:
		second_timer -= 1.0
		update_energy()
>>>>>>> Stashed changes
