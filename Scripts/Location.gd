extends Node

class_name Location, "res://icon.png"

var instancename = "location"

export var location_name = ""
export var introduction_text = ""
export(float, 0, 1, 0.01) var room_size

var visited = false
var current_audio_position = 0
export(bool) var always_restart_bg_audio = false
export(AudioStream) var introduction_audio
export(AudioStream) var background_audio

export var background_audio_volume_db = 0.0
export(Texture) var bg_image

#export(TRANSITION_AUDIO) var transition_audio = TRANSITION_AUDIO.none

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

