extends Node

#Time based scheduler for all game events, cutscenes, etc

onready var character_list = get_children()




func _process(delta: float) -> void:
	
	#trigger global game events based on certain conditions
	
	
	#loop through all characters
	for character in character_list:
		
		#update based on the required behaviour script
		character.check_schedule()
		
		#take action based on current location
		if G.earth_time == "08:00:00":
			character.try_move("Living Area")
		
		if G.earth_time == "08:00:05":
			character.try_move("Study")

