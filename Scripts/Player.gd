extends Node

export var player_name = ''
export var current_location = 'Quarters'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func change_location( location ):
	
	#is this a valid location (TO DO)
	current_location = location

#	#Get link to current location
	var location_node = get_tree().get_current_scene().get_node(current_location)
	var audio_controller = get_tree().get_current_scene().get_node("AudioController")

	audio_controller.audio_transition( location_node.background_audio, location_node.background_audio_volume_db )
#
##	#Was it the first visit? If so queue the audio
	if (!location_node.visited):
		if (location_node.introduction_audio):
			audio_controller.queue_narration( location_node.introduction_text, location_node.introduction_audio )
#
#	#set location as visited by player
	location_node.visited = true
