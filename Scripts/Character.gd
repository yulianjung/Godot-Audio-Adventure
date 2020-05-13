extends Node

var instancename = "character"
class_name Character, "res://Assets/Icons/character.png"

export var visible = true

export (NodePath) var current_location
var previous_location #(NodePath) 
var time_arrived = OS.get_system_time_secs() #time arrived at current location

export (Texture) var face

export (Color) var color # COLOR OF THE TEXT

export (float, 0.1, 1.9) var voice_pitch # HOW HIGH / LOW THE VOICE IS

export (String, FILE) var interaction_script # A JSON DIALOGUE FILE

export (Script) var behaviour_script

export var verbs = ["","","","","",""]

onready var player = get_tree().get_current_scene().get_node("Player")

var behaviour = null

var current_schedule_idx = -1


var start_time = ""
var path = []
var movement_type = "sequential"
var looped_movement = false
var speed = 10 #time taken between pathing
var path_idx = 0

func set_schedule(idx):
	start_time = behaviour.schedule[idx]["starttime"]
	path = behaviour.schedule[idx]["paths"]
	movement_type = behaviour.schedule[idx]["movement"]
	looped_movement = behaviour.schedule[idx]["looped_movement"]
	speed = behaviour.schedule[idx]["speed"]
	path_idx = 0
	if G.pathfinding_debug:
		print("We just set schedule to ",start_time, " for ", name)


func talk():
#	print("talking to " + self.name)
	MSG.start_dialogue(interaction_script, self)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load the script for character if not already loaded
	if behaviour_script != null and behaviour == null:
		behaviour = behaviour_script.new()
		behaviour.load_schedule()
		if G.pathfinding_debug:
			print( "Loaded Behaviour for ", name)
		



#pass in string, name of target location and then attempt to move player there
func try_move( target_location: String ) -> bool:
	
	var target_exit = null
	var success = false
	
	time_arrived = OS.get_system_time_secs()
	
	if G.pathfinding_debug:
		print(name, " is trying to enter ",target_location)
	
	#check character has a current location
	if !get_current_location_object():
		push_error(name+ " needs current location set")
		return success
	
	#check for exit in current location that matches target_location
	for exit in get_current_location_object().get_children():
		
		#only process exit instances
		if exit.instancename != "exit":
			continue
				
		#if target location is not set, crash out and flag the error
		if (exit.target_location == null):
			push_error("ERROR: No target location set for " + exit.name)

		if (target_location == G.extract_node(exit.target_location)):
			target_exit = exit
			if G.pathfinding_debug:
				print("Found exit ", target_location, " for player ", name)
			
	#if we found a target_exit then send the user through the exit
	#TO DO
	if target_exit != null:
		success = true
		if G.pathfinding_debug:
			print(name, " is using exit to ",target_location)
		#move the npc triggering any audio
		move( target_exit )
		return success
	else:
		if G.pathfinding_debug:
			print(name, " can't find exit to ",target_location)
	
	return success


#move NPC through a given exit irrespective of the players location
func move( exit ):
	
	#update our current location Nodepath 
	previous_location = current_location
	current_location = exit.target_location
	
	#Get the final node name for the target location we want to take the player to
	#var target_location = exit.target_location_node

	#get link to audiocontroller
	var audio_controller = get_tree().get_current_scene().get_node("AudioController")

	#check if previous location is players current location, if so play the exit audio
	if player.current_location == previous_location:
		if exit.exit_audio != "none":
			audio_controller.play_npc_transition( exit.exit_audio )
	
	#check if current location is players current location, if so play the arrival audio
	if player.current_location == current_location:
		if exit.arrival_audio != "none":
			audio_controller.play_npc_transition ( exit.arrival_audio )
	
	get_tree().get_current_scene().update_gui()
	




# Check to see if character should load a new behaviour script
func check_schedule():

	#check if behaviour is within a given timeframe and set active schedule
	var current_time = G.get_time()
	var next_idx = 0
	
	if current_schedule_idx == -1:
		current_schedule_idx = 0
		set_schedule(current_schedule_idx)
	
	if current_schedule_idx+1 >= behaviour.schedule.size():
		next_idx = 0
	else:
		next_idx = current_schedule_idx+1
	
	if (current_time > G.time(G.e_days, behaviour.schedule[next_idx]["starttime"])):
		current_schedule_idx = next_idx
		set_schedule(current_schedule_idx)
		

# Check to see how character should behave
func check_behaviour() -> void:
	
	#see how long it's been since the NPC moved
	var since_last_moved = OS.get_system_time_secs() - time_arrived
		
	print (name, " has been here for ", since_last_moved)
		
	#move the character along the path and update the index if it's time
	if since_last_moved > speed:
		try_move( path[path_idx] )
		
		if (name == "AI"):
			print("IS ",path.size()," < ", path_idx + 1)
		if path_idx + 1 < path.size():
			path_idx += 1




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




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
