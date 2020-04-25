extends Node

var instancename = "exit"

export var visible = true
export var button_text = ""
export (NodePath) var target_location
var target_location_node

export(String, "none",
	"footsteps_indoors",
	"footsteps_indoors_metal",
	"footsteps_outside",
	"enter_lift",
	"exit_lift",
	"lift_change_floor",
	"lift_arrival") var exit_audio
	
export(String, "none",
	"footsteps_indoors",
	"footsteps_indoors_metal",
	"footsteps_outside",
	"enter_lift",
	"exit_lift",
	"lift_change_floor",
	"lift_arrival") var arrival_audio

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#If location is set for an exit then get the node
	if target_location != null && target_location != "":
		self.target_location_node = get_node(target_location)

