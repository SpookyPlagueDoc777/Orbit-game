extends satellite


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
	
func _process(delta: float) -> void:
	update_position()


func _on_area_2d_area_entered(area: Area2D) -> void:
	register_hit(area)
