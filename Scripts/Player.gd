extends Node

var instancename = "player"

var audio_timer1 = 0.0

export var player_name = ''
export (NodePath) var current_location



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func change_location( location, exit_audio, arrival_audio ):
	
	#update our current location Nodepath 
	current_location = location	
	
	#Get the final node name for the target location we want to take the player to
	var target_location = Global.extract_node(location)

	#Get link to target location
	var location_node = get_tree().get_current_scene().get_node(target_location)
	#get link to audiocontroller
	var audio_controller = get_tree().get_current_scene().get_node("AudioController")

	#fade in new audio (and fade out old one)
	audio_controller.audio_transition( location_node.background_audio, location_node.background_audio_volume_db )
	
	#Play The Exit Audio	
	if exit_audio != "none":
		audio_timer1 = audio_controller.play_location_transition ( exit_audio )

	#Was it the first visit? If so queue the introduction audio
	if (!location_node.visited):
		if (location_node.introduction_audio):
			audio_controller.queue_narration( location_node.introduction_text, location_node.introduction_audio )

	#set location as visited by player
	location_node.visited = true

	if exit_audio != "none":
		yield(get_tree().create_timer(audio_timer1), "timeout")
	#Play The Arrival Audio	
	if arrival_audio != "none":
		audio_controller.play_location_transition ( arrival_audio )



#converts relative node to single node string
func get_location():
	return Global.extract_node(current_location)
