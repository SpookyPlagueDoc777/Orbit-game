extends Node
<<<<<<< Updated upstream
# global
=======
# In Petagrams

@warning_ignore("unused_signal")
signal updatelist
>>>>>>> Stashed changes

const G: float = 66.743
const planetmass: int = 40752

<<<<<<< Updated upstream
var spinspeed: float = 0
var energy: int = 300
var timelimit: int = 0
var quota: float = 0
=======
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
>>>>>>> Stashed changes
