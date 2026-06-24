extends Node

@onready var energy_amount: Label = $CanvasLayer/GameUI/Energyindicator/VBoxContainer/EnergyAmount
@onready var timer: Timer = $Timer
@onready var current_time: Label = $CanvasLayer/GameUI/Timer/CurrentTime
@onready var spin_quota: Label = $CanvasLayer/GameUI/SpinQuotaMenager/VBoxContainer/CurrentQuota
@onready var time_to_meet_quota: Label = $CanvasLayer/GameUI/SpinQuotaMenager/VBoxContainer/TimeToMeetQuota
@onready var current_spin_speed: Label = $CanvasLayer/GameUI/SpinIndicator/CurrentSpinSpeed

#timer stuff
var TimerSeconds = 0
var TimerMinutes = 0
var TimerHours = 0

var SpinSpeed = 0
var energy = 300
var TimeLimit = 0
var CurrentQuota = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	energy_amount.text = str(energy)
	current_time.text = str(TimerHours) + "h " + str(TimerMinutes) + "m " + str(TimerSeconds) + "s"
	current_spin_speed.text = str(SpinSpeed) + " km/h"
	spin_quota.text = str(CurrentQuota)
	time_to_meet_quota.text = str(TimeLimit)


func _on_timer_timeout() -> void:
	TimerSeconds += 1
	if TimerSeconds == 60:
		TimerSeconds = 0
		TimerMinutes += 1
	if TimerMinutes == 60:
		TimerMinutes = 0
		TimerHours += 1
