extends Node

@onready var energy_amount: Label = $CanvasLayer/GameUI/Energyindicator/VBoxContainer/EnergyAmount
@onready var timer: Timer = $Timer
@onready var current_time: Label = $CanvasLayer/GameUI/Timer/CurrentTime
@onready var spin_quota: Label = $CanvasLayer/GameUI/SpinQuotaMenager/VBoxContainer/CurrentQuota
@onready var time_to_meet_quota: Label = $CanvasLayer/GameUI/SpinQuotaMenager/VBoxContainer/TimeToMeetQuota
@onready var current_spin_speed: Label = $CanvasLayer/GameUI/SpinIndicator/CurrentSpinSpeed

#timer stuff
var TimerSeconds: int = 0
var TimerMinutes: int = 0
var TimerHours: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	energy_amount.text = str(Global.energy)
	current_time.text = str(TimerHours) + "h " + str(TimerMinutes) + "m " + str(TimerSeconds) + "s"
	current_spin_speed.text = str(Global.spin_speed) + " rad/h"
	spin_quota.text = str(Global.quota)
	time_to_meet_quota.text = str(Global.time_limit)


func _on_timer_timeout() -> void:
	TimerSeconds += 1
	if TimerSeconds == 60:
		TimerSeconds = 0
		TimerMinutes += 1
	if TimerMinutes == 60:
		TimerMinutes = 0
		TimerHours += 1


func _on_pause_button_toggled(toggled_on: bool) -> void:
	timer.paused = !toggled_on
	Global.is_paused = !toggled_on
