extends Node

@onready var energy_amount: Label = $CanvasLayer/GameUI/Energyindicator/VBoxContainer/EnergyAmount
@onready var timer: Timer = $Timer
@onready var current_time: Label = $CanvasLayer/GameUI/Timer/CurrentTime
@onready var spin_quota: Label = $CanvasLayer/GameUI/SpinQuotaMenager/VBoxContainer/CurrentQuota
@onready var time_to_meet_quota: Label = $CanvasLayer/GameUI/SpinQuotaMenager/VBoxContainer/TimeToMeetQuota
@onready var current_spin_speed: Label = $CanvasLayer/GameUI/SpinIndicator/CurrentSpinSpeed
@onready var game_ui: Control = $CanvasLayer/GameUI

#timer stuff
var TimerSeconds: int = 0
var TimerMinutes: int = 0
var TimerHours: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveManager.save_completed.connect(_on_save_completed)
	if SaveManager.has_save():
		SaveManager.load_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
<<<<<<< Updated upstream
	energy_amount.text = str(Global.energy)
	current_time.text = str(TimerHours) + "h " + str(TimerMinutes) + "m " + str(TimerSeconds) + "s"
	current_spin_speed.text = str(Global.spinspeed) + " rad/h"
	spin_quota.text = str(Global.quota)
	time_to_meet_quota.text = str(Global.timelimit)
=======
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
	
>>>>>>> Stashed changes


func _on_timer_timeout() -> void:
	TimerSeconds += 1
	if TimerSeconds == 60:
		TimerSeconds = 0
		TimerMinutes += 1
	if TimerMinutes == 60:
		TimerMinutes = 0
		TimerHours += 1


func _on_autosave_timer_timeout() -> void:
	save()


func save():
	SaveManager.save_game()


func _on_save_completed() -> void:
	game_ui.show_save_notification()
