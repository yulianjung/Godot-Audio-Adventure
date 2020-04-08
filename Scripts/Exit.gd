extends Node

export var button_text = ""
export (NodePath) var target_location
#export(preload("res://Scripts/audio_library.gd").TRANSITION_AUDIO) var transition_audio #preloads all transition audio file names

export(String, "none",
	"footsteps_indoors",
	"footsteps_outside",
	"enter_lift",
	"exit_lift",
	"lift_change_floor",
	"lift_arrival") var exit_audio
	
export(String, "none",
	"footsteps_indoors",
	"footsteps_outside",
	"enter_lift",
	"exit_lift",
	"lift_change_floor",
	"lift_arrival") var arrival_audio


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

