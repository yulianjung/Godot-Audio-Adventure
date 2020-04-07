extends Node

export var button_text = ""
export (NodePath) var target_location
export(preload("res://Scripts/audio_library.gd").TRANSITION_AUDIO) var transition_audio #preloads all transition audio file names



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

