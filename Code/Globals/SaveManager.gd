extends Node
# ---------------------------------------------------------------------------
# SaveManager 
# ---------------------------------------------------------------------------
 
const SAVE_PATH := "user://savegame.cfg"
const SATELLITE_SCENE: PackedScene = preload("res://Scenes/Game/GameClass/satellite.tscn")
 
signal save_completed
signal load_completed(success: bool)
 
 
func save_game(satellites_parent: Node = null, main_scene: Node = null) -> void:
	if satellites_parent == null:
		satellites_parent = _get_satellites_parent()
	if main_scene == null:
		main_scene = get_tree().current_scene
 
	var config := ConfigFile.new()
 
	# --- Global (meta) progress ---
	config.set_value("global", "energy", Global.energy)
	config.set_value("global", "timelimit", Global.timelimit)
	config.set_value("global", "quota", Global.quota)
	config.set_value("global", "spinspeed", Global.spinspeed)
 
	# --- Playtime ---
	if main_scene:
		config.set_value("timer", "seconds", main_scene.TimerSeconds)
		config.set_value("timer", "minutes", main_scene.TimerMinutes)
		config.set_value("timer", "hours", main_scene.TimerHours)
 
	# --- Active satellites ---
	var satellites: Array = get_tree().get_nodes_in_group("satellites")
	var satellite_data: Array = []
	for sat in satellites:
		satellite_data.append({
			"satellitename": sat.satellitename,
			"health": sat.health,
			"orbitradius": sat.orbitradius,
			"facesplanet": sat.facesplanet,
			"baseangle": sat.baseangle,
			"satenergyprod": sat.satenergyprod,
			"satenergylaunch": sat.satenergylaunch,
			"satspinprod": sat.satspinprod,
			"orbitspeed": sat.orbitspeed,
			"launchanimation": sat.launchanimation,
		})
	config.set_value("satellites", "list", satellite_data)
 
	var err := config.save(SAVE_PATH)
	if err == OK:
		print("Game saved to ", SAVE_PATH)
	else:
		push_error("Failed to save game: %s" % err)
	save_completed.emit()
 
 
func load_game(satellites_parent: Node = null, main_scene: Node = null) -> bool:
	if satellites_parent == null:
		satellites_parent = _get_satellites_parent()
	if main_scene == null:
		main_scene = get_tree().current_scene
 
	var config := ConfigFile.new()
	var err := config.load(SAVE_PATH)
	if err != OK:
		push_warning("No save file found (or failed to load): %s" % err)
		load_completed.emit(false)
		return false
 
	# --- Global (meta) progress ---
	Global.energy = config.get_value("global", "energy", Global.energy)
	Global.timelimit = config.get_value("global", "timelimit", Global.timelimit)
	Global.quota = config.get_value("global", "quota", Global.quota)
	Global.spinspeed = config.get_value("global", "spinspeed", Global.spinspeed)
 
	# --- Playtime ---
	if main_scene:
		main_scene.TimerSeconds = config.get_value("timer", "seconds", 0)
		main_scene.TimerMinutes = config.get_value("timer", "minutes", 0)
		main_scene.TimerHours = config.get_value("timer", "hours", 0)
 
	# --- Clear any satellites currently in the scene before recreating ---
	for sat in get_tree().get_nodes_in_group("satellites"):
		sat.queue_free()
 
	# --- Recreate saved satellites ---
	var satellite_data: Array = config.get_value("satellites", "list", [])
	for data in satellite_data:
		var sat = SATELLITE_SCENE.instantiate()
		satellites_parent.add_child(sat)
		sat.satellitename = data.get("satellitename", "")
		sat.health = data.get("health", 0.0)
		sat.orbitradius = data.get("orbitradius", 0.0)
		sat.facesplanet = data.get("facesplanet", false)
		sat.baseangle = data.get("baseangle", PI / 4)
		sat.satenergyprod = data.get("satenergyprod", 0)
		sat.satenergylaunch = data.get("satenergylaunch", 0)
		sat.satspinprod = data.get("satspinprod", 0.0)
		sat.orbitspeed = data.get("orbitspeed", 0.0)
		sat.launchanimation = data.get("launchanimation", false)
		sat.add_to_group("satellites")
 
	load_completed.emit(true)
	return true
 
 
# Quick check for menus ("Continue" button, etc.)
func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)
 
 
func delete_save() -> void:
	if has_save():
		DirAccess.remove_absolute(SAVE_PATH)
 
 

func _get_satellites_parent() -> Node:
	var container := get_tree().get_first_node_in_group("satellites_container")
	if container:
		return container
	push_error("SaveManager: couldn't find a node in group 'satellites_container' - add your satellites container node to that group in the editor, or pass it manually to save_game()/load_game().")
	return get_tree().current_scene
