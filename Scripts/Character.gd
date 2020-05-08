extends Node

var instancename = "character"

export var visible = true

export (NodePath) var current_location
var time_arrived #time arrived at current location
var previous_location #(NodePath) 

export (Texture) var face

export (Color) var color # COLOR OF THE TEXT

export (float, 0.1, 1.9) var voice_pitch # HOW HIGH / LOW THE VOICE IS

export (String, FILE) var interaction_script # A JSON DIALOGUE FILE

export (Script) var behaviour_script

export var verbs = ["","","","","",""]

var behaviour = null

var current_schedule_idx = -1

var start_time = ""
var path = []
var movement_type = "sequential"
var looped_movement = false
var speed = 10 #time taken between pathing

func set_schedule(idx):
	start_time = behaviour.schedule[idx]["starttime"]
	path = behaviour.schedule[idx]["paths"]
	movement_type = behaviour.schedule[idx]["movement"]
	looped_movement = behaviour.schedule[idx]["looped_movement"]
	speed = behaviour.schedule[idx]["speed"]
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
		print( "Loaded Behaviour for ", name)
		



#pass in string, name of target location and then attempt to move player there
func try_move( target_location: String ):
	
	var target_exit = null
	var success = false
	
	#check character has a current location
	if !get_current_location_object():
		push_error(name+ " needs current location set")
		return
	
	#check for exit in current location that matches target_location
	for exit in get_current_location_object().get_children():
		
		#only process exit instances
		if exit.instancename != "exit":
			continue
				
		#if target location is not set, crash out and flag the error
		if (exit.target_location == null):
			push_error("ERROR: No target location set for " + exit.name)

		if (target_location == G.extract_node(exit.target_location)):
			target_exit = exit.target_location
			print("Found exit ", target_location, " for player ", name)
			
	#if we found a target_exit then send the user through the exit
	#TO DO
	if target_exit != null:
		success = true
		

	return success



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
