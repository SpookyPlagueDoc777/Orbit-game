extends Node
# In Petagrams

signal updatelist

const G: float = 66.743
const planetmass: int = 40752

const SPINSPEEDSTART: float = 0
const ENERGYSTART: int = 1000
const TIMELIMITCSTART: int = 0
const TIMELIMITYSTART: int = 1
const TIMELIMITDSTART: int = 0
const QUOTASTART: float = 0.005

var is_paused: bool = true

var spin_speed: float = SPINSPEEDSTART
var energy: int = ENERGYSTART
var time_limit_c: int = TIMELIMITCSTART
var time_limit_y: int = TIMELIMITYSTART
var time_limit_d: int = TIMELIMITDSTART
var quota: float = QUOTASTART
var upgrade_all: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


	
