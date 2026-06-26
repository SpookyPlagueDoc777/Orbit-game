extends Node

@onready var sfx_player: AudioStreamPlayer2D = $"../MainNode/CanvasLayer/SFXPlayer"
@onready var music_player: AudioStreamPlayer2D = $"../MainNode/CanvasLayer/MusicPlayer"

const CLICK = preload("uid://nkcnhb6kawop")
const DECLICK = preload("uid://bj7fvc1pjyr66")
const MUSIC1 = preload("uid://bdv8nduhuyp63")

var clicksound: = CLICK.instantiate_playback()
var declicksound: = DECLICK.instantiate_playback()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_music(MUSIC1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func successful_push() -> void:
	play_sfx(CLICK)

func unsuccessful_push() -> void:
	play_sfx(DECLICK)

func play_sfx(sound): 
	sfx_player.stream = sound
	sfx_player.play()

func play_music(sound): 
	music_player.stream = sound
	music_player.play()
