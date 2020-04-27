extends Node

var instancename = "player"

var audio_timer1 = 0.0

export var player_name = ''
export (NodePath) var current_location
var previous_location #(NodePath) 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

#moves the player to the target_location
func use_exit( exit ):

	#update our current location Nodepath 
	previous_location = current_location
	current_location = exit.target_location
	
	#Get the final node name for the target location we want to take the player to
	var target_location = exit.target_location_node

	#get link to audiocontroller
	var audio_controller = get_tree().get_current_scene().get_node("AudioController")
	
	#audio_controller.room_size = target_location.room_size
	#print("changed room_size to ",target_location.room_size)

	if target_location.background_audio != null:
		#fade in new audio (and fade out old one)
		audio_controller.background_audio_transition( target_location.background_audio, target_location.background_audio_volume_db )
	
	#Play The Exit Audio	
	if exit.exit_audio != "none":
		audio_timer1 = audio_controller.play_location_transition ( exit.exit_audio )

	#Was it the first visit? If so queue the introduction audio
	if (!target_location.visited):
		if (target_location.introduction_audio):
			audio_controller.queue_narration( target_location.introduction_text, target_location.introduction_audio )

	#set location as visited by player
	target_location.visited = true

	#Play The Leaving Current Location Audio	
	if exit.exit_audio != "none":
		yield(get_tree().create_timer(audio_timer1), "timeout")
	
	#Play The Arriving at Target Location Audio	
	if exit.arrival_audio != "none":
		audio_controller.play_location_transition ( exit.arrival_audio )
	


#converts relative node to single node string
func get_current_location_node():
	return G.extract_node(current_location)
	
#returns current node for player location
func get_current_location_object():
	var location = get_current_location_node()
	return get_tree().get_current_scene().get_node(location)

#converts relative node to single node string
func get_previous_location_node():
	return G.extract_node(previous_location)
	
#returns previous node for player location
func get_previous_location_object():
	var location = get_previous_location_node()
	return get_tree().get_current_scene().get_node(location)

