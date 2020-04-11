extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var audio_controller = get_tree().get_current_scene().get_node("AudioController")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



#LIST OF USEFUL COMMANDS

#AUDIO
#audio_controller.change_background_audio( "filename.ogg", permanent_flag )  #file must be in the background folder. Permanent_flag bool, will up date the location audio file
#audio_controller.queue_narration( "Text to show on the screen", "filename.ogg" ) #file must be in the narration folder




func Object_Family_Photo(verb):
	
	match verb.to_lower():
		"examine":
			audio_controller.queue_narration( "It's a picture of my mum, she was 8 months pregnant with me", "object-family-photo-examine.ogg" )


func Object_TV(verb):
	
	match verb.to_lower():
		"turn on":
			audio_controller.change_background_audio( "bg-livingarea+tv.ogg" )
			#audio_controller.queue_narration( "I picked up the picture frame and threw it against the wall, damn it, why did he have to leave", "object_picture_smash.ogg" )
			#print("You smash the picture frame!")

func Object_Excomm_Magazine(verb):
	
	match verb.to_lower():
		"read article":
			audio_controller.queue_narration( "When I was a kid I wanted to visit Earth, but after the death of my father I wasn't interested in going home - home was Europa. My path was to continue my parents' journey in the field of science.", "object_excomm_magazine_examine.ogg" )
