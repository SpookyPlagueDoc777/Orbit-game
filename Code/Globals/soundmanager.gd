extends Node

@onready var sfx_player: AudioStreamPlayer2D = $"../MainNode/CanvasLayer/SFXPlayer"
var music_player: AudioStreamPlayer = null # Changed to standard variable

const CLICK = preload("uid://nkcnhb6kawop")
const DECLICK = preload("uid://bj7fvc1pjyr66")
const MUSIC1 = preload("uid://bdv8nduhuyp63")

func start() -> void:
	play_music(MUSIC1)

func successful_push() -> void:
	play_sfx(CLICK)

func unsuccessful_push() -> void:
	play_sfx(DECLICK)

func play_sfx(sound: AudioStream) -> void:
	if sfx_player:
		sfx_player.stream = sound
		sfx_player.play()

func play_music(sound: AudioStream) -> void:
	music_player = get_tree().get_first_node_in_group("music_player")
	
	if music_player:
		music_player.stream = sound
		music_player.play()
	else:
		push_error("SoundManager Error: No node found in group 'music_player'!")
