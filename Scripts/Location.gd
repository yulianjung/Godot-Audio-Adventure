extends Node

export var location_name = ""
export var introduction_text = ""

var visited = false
export(AudioStream) var introduction_audio
export(AudioStream) var background_audio
export var background_audio_volume_db = 0.0
export(Texture) var bg_image

#export(TRANSITION_AUDIO) var transition_audio = TRANSITION_AUDIO.none

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


