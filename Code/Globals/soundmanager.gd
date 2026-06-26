extends Node

@onready var sfx_player: AudioStreamPlayer2D = $"../MainNode/CanvasLayer/SFXPlayer"

const CLICK = preload("uid://nkcnhb6kawop")
const DECLICK = preload("uid://bj7fvc1pjyr66")

var clicksound: = CLICK.instantiate_playback()
var declicksound: = DECLICK.instantiate_playback()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func successful_push() -> void:
	play_sound(CLICK)

func unsuccessful_push() -> void:
	play_sound(DECLICK)

func play_sound(sound): 
	sfx_player.stream = sound
	sfx_player.play()
