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


#timer stuff
var TimerSeconds: int = 0
var TimerMinutes: int = 0
var TimerHours: int = 0

func check_quota() -> bool:
	var check: bool
	if Global.spin_speed >= Global.quota:
		check = true
	else:
		check = false
	return check

func check_timer_limit_reached() -> void:
	if TimerHours >= Global.time_limit_h:
			if TimerMinutes >= Global.time_limit_m:
					if TimerSeconds >= Global.time_limit_s and check_quota() == false:
						game_over.visible = true
						Engine.time_scale = 0.1
						game_over_timer.start()

func check_quota_reached() -> void:
	if check_quota() == true:
		game_won.visible = true
		Engine.time_scale = 0.1
		game_won_timer.start()

func _on_game_won_timer_timeout() -> void:
	Engine.time_scale = 1
	Global.quota = randf_range(Global.spin_speed + 0.001, 2 * Global.quota)
	

func _on_game_over_timer_timeout() -> void:
	Engine.time_scale = 1
	for i in satellites.get_children():
		i.queue_free()
	get_tree().reload_current_scene()

	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#updating lables
	energy_amount.text = str(round(Global.energy))
	current_time.text = str(TimerHours) + "h " + str(TimerMinutes) + "m " + str(TimerSeconds) + "s"
	current_spin_speed.text = str(snappedf(Global.spin_speed, 0.001)) + " rad/h"
	spin_quota.text = str(Global.quota)
	time_to_meet_quota.text = str(Global.time_limit_h) + "h " + str(Global.time_limit_m) + "m " + str(Global.time_limit_s) + "s"
	
#timer
func _on_timer_timeout() -> void:
	TimerSeconds += 1
	if TimerSeconds == 60:
		TimerSeconds = 0
		TimerMinutes += 1
	if TimerMinutes == 60:
		TimerMinutes = 0
		TimerHours += 1
	check_timer_limit_reached()
	check_quota_reached()
	

func _on_pause_button_toggled(toggled_on: bool) -> void:
	timer.paused = !toggled_on
	Global.is_paused = !toggled_on
