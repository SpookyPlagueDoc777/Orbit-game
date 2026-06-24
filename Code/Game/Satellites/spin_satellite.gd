extends satellite


func _ready() -> void:
	## Satellite info
	satellitename = "Spin Satellite"
	health = 5
	facesplanet = true
	orbitradius = 100
	
	## Satellite stats
	satenergyprod = 0
	satenergylaunch = 500
	satspinprod = 0.0005
	
	launch()
	
func _process(delta: float) -> void:
	update_position()


func _on_area_2d_area_entered(area: Area2D) -> void:
	register_hit(area)
