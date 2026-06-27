extends Node

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

const PAUSE_BUTTON = preload("uid://bvkfsrq12bvn3")
const PLAY_BUTTON = preload("uid://bmkpnomnr3dfm")

#timer stuff
var TimerDays: int = 0
var TimerYears: int = 0
var TimerCenturies: int = 0

func check_quota() -> bool:
	var check: bool
	if Global.spin_speed >= Global.quota:
		check = true
	else:
		check = false
	return check

func check_timer_limit_reached() -> void:
	if TimerCenturies >= Global.time_limit_c && TimerYears >= Global.time_limit_y && TimerDays >= Global.time_limit_d:
		check_quota_reached()
		

func check_quota_reached() -> void:
	if check_quota():
		Global.quota = snappedf(randf_range(Global.quota + 0.002, Global.quota * 4),0.001)
		game_won.text = "Quota Reached!\nNew Quota: " + str(snappedf(Global.quota,0.0001))
		game_won.visible = true
		game_won_timer.start()
		Global.time_limit_y += 1
		if Global.time_limit_y >= 100:
			Global.time_limit_y = 0
			Global.time_limit_c += 1
	else:
		game_over.visible = true
		game_over_timer.start()
	Engine.time_scale = 0.1

func _on_game_won_timer_timeout() -> void:
	Engine.time_scale = 1
	game_won.visible = false
	

func _on_game_over_timer_timeout() -> void:
	Engine.time_scale = 1
	for i in satellites.get_children():
		i.queue_free()
	game_over.visible = false
	get_tree().reload_current_scene()

	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#updating lables
	if Global.is_paused && !timer.paused:
		timer.paused = true
	elif !Global.is_paused && timer.paused:
		timer.paused = false
	energy_amount.text = str(round(Global.energy))
	current_time.text = str(TimerCenturies) + "c " + str(TimerYears) + "y " + str(TimerDays) + "d"
	current_spin_speed.text = str(snappedf(Global.spin_speed, 0.0001)) + " rad/h"
	spin_quota.text = str(snappedf(Global.quota,0.0001)) + " rad/h"
	time_to_meet_quota.text = str(Global.time_limit_c) + "c " + str(Global.time_limit_y) + "y " + str(Global.time_limit_d) + "d"
	
#Timer
func _on_timer_timeout() -> void:
	TimerDays += 1
	if TimerDays >= 365:
		TimerDays = 0
		TimerYears += 1
	if TimerYears == 100:
		TimerDays = 0
		TimerCenturies += 1
	check_timer_limit_reached()
	

func _on_pause_button_toggled(toggled_on: bool) -> void:
	SoundManager.successful_push()
	timer.paused = !toggled_on
	Global.is_paused = !toggled_on
	if toggled_on:
		pause_button.icon = PAUSE_BUTTON
	else:
		pause_button.icon = PLAY_BUTTON
			
	
