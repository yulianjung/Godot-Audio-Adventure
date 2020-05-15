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
var _path_route = []  #this is set by our path finding algorithm


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
		
	if G.pathfinding_debug:
		print (name, " has been here for ", since_last_moved)
		
	#move the character along the path and update the index if it's time
	if since_last_moved > speed:
		try_move( path[path_idx] )
		
		if path_idx + 1 < path.size():
			path_idx += 1

	print ("PATH FIND RETURNED: ", pathfind( "Balcony", "Elevator Living Area" ))


#returns the lowest distance node in unsettled nodes
func get_lowest_node_distance( unsettledNodes:Array ) -> int:
	
	var lowestDistanceNode = 0;
	var lowestDistance = 999999999;
	var nodeDistance
	var idx = 0

	for node in unsettledNodes:
		nodeDistance = node.distance;
		if nodeDistance < lowestDistance:
			lowestDistance = nodeDistance
			lowestDistanceNode = idx
		idx += 1

	return lowestDistanceNode


# return index
func node_exists( node_name, search_array ):
	var idx = 0
	
	for node in search_array:
		if node_name == node.location_name:
			return idx
		idx += 1
	
	return false


func pathfind( start_location:String, end_location:String) -> Array:
	
	var all_locations = []
	
	#initialise containers for tracking our process
	var settled_nodes = []
	var unsettled_nodes = []
	var current_node = route_node.new()
	var new_neighbour = route_node.new()
	var	current_node_idx
	var target_node
	var adj_node
	var node_index
	var weight
	var checksum
	
#	#declare our starting point with a zero distance
#	var source = route_node.new()
#	source.distance = 0
#	source.location_name = start_location
#	unsettled_nodes.append(source)
#
#	while unsettled_nodes.size() != 0:
#		current_node_idx = get_lowest_node_distance(unsettled_nodes)
#		current_node = unsettled_nodes[ current_node_idx ]
#		unsettled_nodes.remove(current_node_idx)
#
#		target_node = get_node_by_name(current_node.location_name)
#
#		if target_node == null:
#			push_error("Path finder was given a non-existance location: "+current_node.location_name)
#
#		#check all exits for our current node
#		for exit in target_node.get_children():
#
#			#only process exits
#			if !exit.is_in_group("exits"):
#				continue
#
#			weight = exit.distance
#
#			adj_node = get_node_by_name( G.extract_node(exit.target_location) )
#
#			#add this node if not settled
#			if not node_exists( adj_node.location_name, unsettled_nodes) and not node_exists( adj_node.location_name, settled_nodes):
#				new_neighbour = route_node.new()
#				new_neighbour.location_name = adj_node.location_name
#				unsettled_nodes.append(new_neighbour)
#
#			node_index = node_exists( adj_node.location_name, unsettled_nodes)
#
#			#if the node exists as an unsettled node then add to the distance
#			if node_index:
#				checksum = weight + current_node.distance
#				if checksum < unsettled_nodes[node_index].distance:
#					unsettled_nodes[node_index].distance = checksum
			
			
#			new_neighbour = route_node.new()
#			source.distance = 0
#			source.location_name = start_location
#			unsettled_nodes.append(source)
			
			
#		for (Entry < Node, Integer> adjacencyPair: currentNode.getAdjacentNodes().entrySet()) 
#		{
#            Node adjacentNode = adjacencyPair.getKey();
#            Integer edgeWeight = adjacencyPair.getValue();
#            if (!settledNodes.contains(adjacentNode)) {
#                calculateMinimumDistance(adjacentNode, edgeWeight, currentNode);
#                unsettledNodes.add(adjacentNode);
#            }
#        }


#	obj = route_node.new()	
#	obj.distance = 12
#	all_locations.append(obj)
#
#	obj = route_node.new()	
#	obj.distance = 15
#	all_locations.append(obj)
#
#	#create a list of all locations starting with our current location
#	for locations in G.get_locations():
#		pass
		
		# we will work our way through all locations calculating distance from start_location
		# [ location1: 0, location2: 999999, location3: 999999, location4: 999999 ]
		
		#for each location 
		#loop through exits (current node) to other locations and 
		# only increment distance values in all_location dict if the value is smaller than the current value
	
	
	
	return _path_route




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
	return get_tree().get_root().find_node(node, true, false)

#Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	add_to_group("characters")

func _exit_tree() -> void:
	remove_from_group("characters")
