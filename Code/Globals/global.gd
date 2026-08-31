extends Node
# In Petagrams

@warning_ignore("unused_signal")
signal updatelist
@warning_ignore("unused_signal")
signal satellite_upgraded(sat_node: Node)

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




	
