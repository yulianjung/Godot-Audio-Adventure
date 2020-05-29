extends Node

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
onready var audio_controller = get_tree().get_current_scene().get_node("AudioController")

var behaviour = null
var current_schedule_idx = -1
var path_route = []  #this is set by our path finding algorithm
var _has_greeted_player = false
var _repeat_probability = 0.25

var start_time = ""
var path = []
var _temp_path

var movement_type = "sequential"
var looped_movement = false
var speed = 10 #time taken between pathing
var path_idx = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load the script for character if not already loaded
	if behaviour_script != null and behaviour == null:
		behaviour = behaviour_script.new()
		behaviour.load_schedule()
		if G.pathfinding_debug:
			print( "Loaded Behaviour for ", name)
			
	get_tree().get_current_scene().get_node("AudioController").connect("npc_transition_in_finished", self, "_on_AudioController_npc_transition_in_finished")
	get_tree().get_current_scene().get_node("AudioController").connect("npc_transition_out_finished", self, "_on_AudioController_npc_transition_out_finished")



func set_schedule(idx):
	start_time = behaviour.schedule[idx]["starttime"]
	path = behaviour.schedule[idx]["paths"]
	movement_type = behaviour.schedule[idx]["movement"]
	
	#check if we need to update current player position
	if path[0].to_lower() == "current":
		path[0] = get_current_location_node()

	#generate path for movement based on sequential route
	if (movement_type.to_lower() == "sequential"):
		
		#ensure sequential path only has two nodes
		if (path.size() > 2):
			push_error("More than 2 locations for a sequential path for "+name)
		
		#generate path
		_temp_path = G.get_game().location_map.get_route_by_name(path[0], path[1])
		path_route = [] #clear out current path and update with full pathfinder
		for node in _temp_path:
			path_route.append( node.get_location().name )
	
	#generate path for movement based on sequential route
	if (movement_type.to_lower() == "static"):
		
		#ensure sequential path only has two nodes
		if (path.size() > 1):
			push_error("More than 1 location for a static path for "+name)
	
		path_route = path
	
	#generate path for movement based on sequential route
	if (movement_type.to_lower() == "random"):
		
		path_route = path	
	
	
	looped_movement = behaviour.schedule[idx]["looped_movement"]
	speed = behaviour.schedule[idx]["speed"]
	path_idx = 0
	if G.pathfinding_debug:
		print("We just set schedule to ",start_time, " for ", name)


func talk():
#	print("talking to " + self.name)
	MSG.start_dialogue(interaction_script, self)





#pass in string, name of target location and then attempt to move NPC there
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
		if !(exit is Exit):
			continue
				
		#if target location is not set, crash out and flag the error
		if (exit.target_location == null):
			push_error("ERROR: No target location set for " + exit.name)

		if (target_location == G.extract_node(exit.target_location)):
			target_exit = exit
			if G.pathfinding_debug:
				print("Found exit ", target_location, " for NPC ", name)
			
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


#move NPC through a given exit irrespective of the NPC's location
func move( exit ):
	
	#update our current location Nodepath 
	previous_location = current_location
	current_location = exit.target_location
	
	#Get the final node name for the target location we want to take the NPC to
	#var target_location = exit.target_location_node

	#check if previous location is player's current location, if so play the exit audio
	if player.current_location == previous_location:
		if exit.exit_audio != "none":
			audio_controller.play_npc_transition( exit.exit_audio, "out", name )
	
	#check if current location is player's current location, if so play the arrival audio
	if player.current_location == current_location:
		if exit.arrival_audio != "none":
			audio_controller.play_npc_transition ( exit.arrival_audio, "in", name )
			

	
	get_tree().get_current_scene().update_gui()
	

func _on_AudioController_npc_transition_out_finished( name_of_character = "" ) -> void:
	
	if name != name_of_character:
		return
	
	#make decision if NPC should greet player
	#print("Transition out for ",name)
	pass # Replace with function body.

#triggered when an NPC arrives at your location
func _on_AudioController_npc_transition_in_finished( name_of_character = "" ) -> void:

	if name != name_of_character:
		return
	
	#print("Transition in for ",name)
	
	if name == "Jove":
		return
	
	if name == "Graham":
		pass
	
	if (behaviour.audio_npc_enters.size() > 0):
		randomize()
		var sound_to_play = randi() % behaviour.audio_npc_enters.size()
		var roll_the_dice = (randi() % 100) / 100
		
		#has graham said anything before? we want to trigger the first time.
		if not _has_greeted_player:
			#get sound to load randomly from character script object TO DO
			audio_controller.play_npc_audio( behaviour.audio_npc_enters[sound_to_play], name )
			_has_greeted_player = true
		else:
			if (roll_the_dice < _repeat_probability):
				audio_controller.play_npc_audio( behaviour.audio_npc_enters[sound_to_play], name )



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
		
	if G.pathfinding_debug:
		print (name, " has been here for ", since_last_moved)
		
	#move the character along the path and update the index if it's time
	if since_last_moved > speed:
		
		#generate path for movement based on sequential route
		if (movement_type.to_lower() == "random"):
			randomize()
			
			#generate random target node location
			var random_idx = randi() % path.size()
	
			#We generate a sequential path to the next location in which they take one move, then we regenerate the path again.
			_temp_path = G.get_game().location_map.get_route_by_name(get_current_location_node(), path[ random_idx ] )
			
			path_idx = 0 #reset the index and start again
			path_route = [] #clear out current path and update with full pathfinder
			for node in _temp_path:
				path_route.append( node.get_location().name )
			
		#only try to move if we have a valid path
		if path_route.size() > 0:
			try_move( path_route[path_idx] )
		
		if path_idx + 1 < path_route.size():
			path_idx += 1

	#print ("PATH FIND RETURNED: ", pathfind( "Balcony", "Elevator Living Area" ))
	#print( G.get_game().location_map.get_route_by_name("Balcony", "R&D") )



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

func get_node_by_name( node:String ):
	return get_tree().get_current_scene().find_node(node, true, true)

#Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	add_to_group("characters")

func _exit_tree() -> void:
	remove_from_group("characters")





