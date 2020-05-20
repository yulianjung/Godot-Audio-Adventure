extends Node

#Time based scheduler for all game events, cutscenes, etc

onready var character_list = get_children()





func _process(delta: float) -> void:
	
	#trigger global game events based on certain conditions
	
	
	#loop through all characters
	for character in character_list:
		
		if (character.name == "Jove"):
			continue
		#update based on the required behaviour script
		character.check_schedule()
		
		character.check_behaviour()
		



