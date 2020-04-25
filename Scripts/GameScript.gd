extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var audio_controller = get_tree().get_current_scene().get_node("AudioController")
onready var player = get_tree().get_current_scene().get_node("Player")
onready var ai = get_tree().get_current_scene().get_node("Characters/AI")
onready var cutscene = get_tree().get_current_scene().get_node("Cutscene")





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.set_pause_mode(2) # Set pause mode to Process
	set_process(true)

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


#HELPER METHODS
#Global.update_gui() 	#updates the gui, useful if you change locations, button names etc as it redraws the screen



########################################################################
#
#
#			     		C H A R A C T E R    S C R I P T S
#
#
########################################################################

func interact_ai():
	#ai.talk()
	
	cutscene.startCutscene()
	
	cutscene.fadeInWhite()
	yield(cutscene, "finished_color_fade")
	
	cutscene.fadeInTitle("CHAPTER 1\nA GOODBYE", "black" )
	yield(cutscene, "finished_title_fade")
	
	cutscene.playFx("footsteps_indoors_metal.ogg")
	#cutscene.fadeOutTitle
	
	#replace this with our new cutscene text
	#audio_controller.queue_narration( "It’s nearly time, Jove. He’s waiting.", "cutscene1-myra1.ogg", true)
	
#	cutscene.fadeInImage( "deleteme.jpg" )
#	yield(cutscene, "finished_image_fade")
#
#	cutscene.fadeOutImage()
#	yield(cutscene, "finished_image_fade")
#
#	print("END OF CUTSCENE")
#	cutscene.end_cutscene()
	#cutscene.fadeOutImage()
	#audio_controller.queue_narration( "Blah blah, not allowed to exit test!", "exit_randd.ogg" )
	return false




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


#elevator button 1
func object_button_floor_1(verb, object):
	
	match verb.to_lower():
		"press":
			#check which floor we are on and take appropriate action
			var current_location = player.get_current_location_node()
			print("Pressed floor 1 and our current_location is ",current_location)
			
			if current_location == "Elevator Living Area":
				audio_controller.queue_narration( "Nothing happened, we are already on this floor", "object_button_same_floor.ogg" )
				return
			if current_location == "Elevator R&D":
				print (" WE NEED TO TAKE USER TO THIS NODE PATH ", object.target_exit)
				#player.use_exit( get_tree().get_current_scene().get_node("/Elevator R&D/Exit_press_floor_1_crew_quarters") )
				player.use_exit( object.target_exit_node )
				G.update_gui() #update the gui
				return
				
			push_error("No script defined for pressing button "+ object.name)

#elevator button 2
func object_button_floor_2(verb, object):
	
	match verb.to_lower():
		"press":
			#check which floor we are on and take appropriate action
			var current_location = player.get_current_location_node()
			print("Pressed floor 2 and our current_location is ",current_location)
			
			if current_location == "Elevator Living Area":
				player.use_exit( object.target_exit_node ) #take user through exit
				G.update_gui() #update the gui
				return
			if current_location == "Elevator R&D":
				audio_controller.queue_narration( "Nothing happened, we are already on this floor", "object_button_same_floor.ogg" )
				return
				
			push_error("No script defined for pressing button "+ object.name)



func object_family_photo(verb, object):
	
	match verb.to_lower():
		"examine":
			audio_controller.queue_narration( "It's a picture of my mum, she was 8 months pregnant with me", "object-family-photo-examine.ogg", true )


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
			audio_controller.queue_narration( "When I was a kid I wanted to visit Earth, but after the death of my father I wasn't interested in going home - home was Europa. My path was to continue my parents' journey in the field of science.", "object_excomm_magazine_examine.ogg", true )
			object.remove_verb("Read Article")
			object.add_verb("Read Another Article")

	match verb.to_lower():
		"read another article":		
			audio_controller.queue_narration( "Nahh, I've read every article, I've even done the crossword.", "object_excomm_magazine_read_another.ogg" )
