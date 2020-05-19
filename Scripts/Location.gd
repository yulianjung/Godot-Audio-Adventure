extends Node

class_name Location, "res://Assets/Icons/location.png"

var instancename = "location"

export var location_name = ""
export var introduction_text = ""
export(float, 0, 1, 0.01) var room_size

var exits:Array
var visited = false
var current_audio_position = 0
export(bool) var always_restart_bg_audio = false
export(AudioStream) var introduction_audio
export(AudioStream) var background_audio

export var background_audio_volume_db = 0.0
export(Texture) var bg_image

#export(TRANSITION_AUDIO) var transition_audio = TRANSITION_AUDIO.none

# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	add_to_group("locations")
	
func _exit_tree() -> void:
	remove_from_group("locations")
	
func _ready() -> void:
#	Pre-retrieve all of the exits when the location is ready.
	var nodes: Array = get_children()
	for node in nodes:
		if node is Exit:
			exits.append(node)
