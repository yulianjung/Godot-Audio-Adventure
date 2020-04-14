extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var audio_controller = get_tree().get_current_scene().get_node("AudioController")
onready var player = get_tree().get_current_scene().get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var tv_counter = 0


#LIST OF USEFUL COMMANDS

#AUDIO
#audio_controller.change_background_audio( "filename.ogg", permanent_flag )  #file must be in the background folder. Permanent_flag bool, will up date the location audio file
#audio_controller.queue_narration( "Text to show on the screen", "filename.ogg" ) #file must be in the narration folder
#audio_controller.play_fx( "filename.ogg")  #Play a sound in the FX folder

#OBJECT VERBS
#object.change_verb(from, to)
#object.add_verb(verb_name) 
#object.remove_verb(verb_name) 

########################################################################
#
#
#			     		E X I T    S C R I P T S
#
#	Return false to prevent player from exiting
#
########################################################################

#A Pre Exit script is called before entering the target exit, if it returns false the player will not be moved
func pre_exit_enter_randd_lift( exit ):
	audio_controller.queue_narration( "Blah blah, not allowed to exit test!", "exit_randd.ogg" )
	return false

#A Post Exit script is called after  entering the target exit
func post_exit_enter_randd_lift( exit ):
	print("Have arrived at exit, call script")
	pass
	

########################################################################
#
#
#					O B J E C T    S C R I P T S
#
#
########################################################################


func object_family_photo(verb, object):
	
	match verb.to_lower():
		"examine":
			audio_controller.queue_narration( "It's a picture of my mum, she was 8 months pregnant with me", "object-family-photo-examine.ogg" )


func object_tv(verb, object):
	
	match verb.to_lower():
		"turn on":
			if tv_counter == 0:
				audio_controller.play_fx( "switch.ogg" )
				audio_controller.change_background_audio( "bg-livingarea+tv.ogg" )
				object.change_verb("Turn On", "Turn Off")
				tv_counter += 1
			else:
				audio_controller.queue_narration( "Nahhh, there's nothing good on", "object_tv_turn_on_again.ogg" )
			#print("You smash the picture frame!")

	match verb.to_lower():
		"turn off":
			audio_controller.play_fx( "switch.ogg" )
			audio_controller.change_background_audio( "bg-livingarea.ogg" )
			object.change_verb("Turn Off", "Turn On")
			#audio_controller.queue_narration( "I picked up the picture frame and threw it against the wall, damn it, why did he have to leave", "object_picture_smash.ogg" )
			#print("You smash the picture frame!")

func object_excomm_magazine(verb,object):
	
	match verb.to_lower():
		"read article":
			audio_controller.play_fx( "page-flip-1.ogg" )
			audio_controller.queue_narration( "When I was a kid I wanted to visit Earth, but after the death of my father I wasn't interested in going home - home was Europa. My path was to continue my parents' journey in the field of science.", "object_excomm_magazine_examine.ogg" )
			object.remove_verb("Read Article")
			object.add_verb("Read Another Article")
			
	match verb.to_lower():
		"read another article":		
			audio_controller.queue_narration( "Nahh, I've read every article, I've even done the crossword.", "object_excomm_magazine_read_another.ogg" )
