extends Node

const PAUSE_BUTTON = preload("uid://bvkfsrq12bvn3")
const PLAY_BUTTON = preload("uid://bmkpnomnr3dfm")

@onready var energy_amount: Label = $CanvasLayer/GameUI/Energyindicator/VBoxContainer/EnergyAmount
@onready var timer: Timer = $Timer
@onready var current_time: Label = $CanvasLayer/GameUI/Timer/CurrentTime
@onready var spin_quota: Label = $CanvasLayer/GameUI/SpinQuotaMenager/VBoxContainer/CurrentQuota
@onready var time_to_meet_quota: Label = $CanvasLayer/GameUI/SpinQuotaMenager/VBoxContainer/TimeToMeetQuota
@onready var current_spin_speed: Label = $CanvasLayer/GameUI/SpinIndicator/CurrentSpinSpeed
@onready var game_over: Label = $CanvasLayer/GameUI/GameOver
@onready var game_won: Label = $CanvasLayer/GameUI/GameWon
@onready var game_over_timer: Timer = $CanvasLayer/GameUI/GameOver/GameOverTimer
@onready var game_won_timer: Timer = $CanvasLayer/GameUI/GameWon/GameWonTimer
@onready var satellites: Node2D = $GameScene/Planet/Satellites
@onready var pause_button: Button = $CanvasLayer/GameUI/PauseButton/PauseButton
@onready var planet: Node2D = $GameScene/Planet
@onready var game_scene: Node2D = $GameScene
@onready var save_timer_auto: Timer = $save_timer_auto
@onready var music_player: AudioStreamPlayer = $CanvasLayer/MusicPlayer
@onready var game_ui: Control = $CanvasLayer/GameUI


var timer_days: int = 0
var timer_years: int = 0
var timer_centuries: int = 0

var TimerDays: int:
	get: return timer_days
	set(val): timer_days = val

var TimerYears: int:
	get: return timer_years
	set(val): timer_years = val

var TimerCenturies: int:
	get: return timer_centuries
	set(val): timer_centuries = val

var _displayed_energy: float = 0.0
var _energy_tween: Tween

func _ready() -> void:
	if SaveManager.has_signal("save_completed"):
		SaveManager.save_completed.connect(_on_save_completed)
	
	timer.paused = true
	SaveManager.load_game()
	SoundManager.start()

func _process(_delta: float) -> void:
	if Global.is_paused != timer.paused:
		timer.paused = Global.is_paused

	_animate_energy_label()
	current_time.text = "%dc %dy %dd" % [timer_centuries, timer_years, timer_days]
	current_spin_speed.text = "%s rad/h" % str(snappedf(Global.spin_speed, 0.0001))
	spin_quota.text = "%s rad/h" % str(snappedf(Global.quota, 0.0001))
	time_to_meet_quota.text = "%dc %dy %dd" % [Global.time_limit_c, Global.time_limit_y, Global.time_limit_d]

func _animate_energy_label() -> void:
	var target_val := roundf(Global.energy)
	if absf(_displayed_energy - target_val) > 0.1:
		if _energy_tween and _energy_tween.is_running():
			_energy_tween.kill()
		_energy_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		_energy_tween.tween_method(func(val: float):
			_displayed_energy = val
			energy_amount.text = str(round(_displayed_energy))
			energy_amount.scale = Vector2(1.15, 1.15)
		, _displayed_energy, target_val, 0.3)
		
		var pop_tween := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		pop_tween.tween_property(energy_amount, "scale", Vector2.ONE, 0.2)

func check_quota() -> bool:
	return Global.spin_speed >= Global.quota

func check_timer_limit_reached() -> void:
	if timer_centuries >= Global.time_limit_c and timer_years >= Global.time_limit_y and timer_days >= Global.time_limit_d:
		check_quota_reached()

func check_quota_reached() -> void:
	if check_quota():
		Global.quota = snappedf(randf_range(Global.quota + 0.1, (Global.quota + 0.1) * 3.0), 0.001)
		game_won.text = "Quota Reached!\nNew Quota: " + str(snappedf(Global.quota, 0.0001))
		_pop_banner(game_won)
		game_won_timer.start()
		
		Global.time_limit_y += 1
		if Global.time_limit_y >= 100:
			Global.time_limit_y = 0
			Global.time_limit_c += 1
	else:
		game_over.text = "Game Over!\nSpin Reached: " + str(Global.spin_speed)
		_pop_banner(game_over)
		game_over_timer.start()
		
		Global.spin_speed = Global.SPINSPEEDSTART
		Global.energy = Global.ENERGYSTART
		Global.time_limit_c = Global.TIMELIMITCSTART
		Global.time_limit_y = Global.TIMELIMITYSTART
		Global.time_limit_d = Global.TIMELIMITDSTART
		Global.quota = Global.QUOTASTART
		Global.upgrade_all = 0
		
		if is_instance_valid(planet):
			planet.rotation = 0.0
			
		timer_days = 0
		timer_years = 0
		timer_centuries = 0
		
	Engine.time_scale = 0.1

func _pop_banner(label_node: Label) -> void:
	label_node.visible = true
	label_node.scale = Vector2.ZERO
	label_node.modulate.a = 0.0
	var tw := create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(label_node, "scale", Vector2.ONE, 0.4)
	tw.tween_property(label_node, "modulate:a", 1.0, 0.3)

func _on_game_won_timer_timeout() -> void:
	Engine.time_scale = 1.0
	_fade_out_banner(game_won)

func _on_game_over_timer_timeout() -> void:
	Engine.time_scale = 1.0
	if is_instance_valid(satellites):
		for child in satellites.get_children():
			child.queue_free()
			
	if Global.has_signal("updatelist"):
		Global.updatelist.emit()
		
	_fade_out_banner(game_over)

func _fade_out_banner(label_node: Label) -> void:
	var tw := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tw.tween_property(label_node, "modulate:a", 0.0, 0.3)
	tw.tween_callback(func(): label_node.visible = false)

func _on_timer_timeout() -> void:
	timer_days += 1
	if timer_days >= 365:
		timer_days = 0
		timer_years += 1
		if timer_years >= 100:
			timer_years = 0
			timer_centuries += 1
			
	check_timer_limit_reached()

func _on_pause_button_toggled(toggled_on: bool) -> void:
	SoundManager.successful_push()
	timer.paused = !toggled_on
	Global.is_paused = !toggled_on
	
	pause_button.pivot_offset = pause_button.size / 2.0
	var btn_tw := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	btn_tw.tween_property(pause_button, "scale", Vector2(1.2, 1.2), 0.1)
	btn_tw.tween_property(pause_button, "scale", Vector2.ONE, 0.15)

	if toggled_on:
		pause_button.icon = PAUSE_BUTTON
	else:
		pause_button.icon = PLAY_BUTTON
		SaveManager.save_game()

func _on_save_completed() -> void:
	if is_instance_valid(game_ui) and game_ui.has_method("show_save_notification"):
		game_ui.show_save_notification()

func _on_save_timer_auto_timeout() -> void:
	SaveManager.save_game()
