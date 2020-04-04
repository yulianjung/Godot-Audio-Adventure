extends Node

export var player_name = ''
export var current_location = 'Quarters'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func change_location( location ):
	
	#is this a valid location (TO DO)
	current_location = location


#	#Get link to current location
	print("/Game/"+current_location)
	var location_node = get_tree().get_current_scene().get_node(current_location)
#
#
##	#Was it the first visit? If so queue the audio
	if (!location_node.visited):
		if (location_node.introduction_audio):
			queue_narration( location_node.introduction_text, location_node.introduction_audio )
			print("Playing Audio - ")
#
#	#set location as visited by player
	location_node.visited = true


	

# Queue Audio Narrator to play audio and display associated text copy
func queue_narration( text, audio ):
	
	#get a link to the current text box
	var text_box = get_tree().get_current_scene().get_node("UserInterface/HBoxContainer/MainScreen-Container/LocationImage/ImageOverlay/BottomOverlay/ColorRect/Narrative")
	var tween = get_tree().get_current_scene().get_node("UserInterface/Tween")
	text_box.text = text
	
	#get the length of the audio to play
	var audio_length = audio.get_length()
	
	$Narrator.set_stream(audio)
	$Narrator.play()	
	
	#fade in
	tween.interpolate_property(text_box, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.2, Tween.TRANS_LINEAR, 0)
	tween.start()
	yield(tween, "tween_completed")
	
	print("Delaying for ",audio_length, " seconds")
	
	#delay depending on number passed in (usually the length of time the seconds the audio lasts)
	yield(get_tree().create_timer(audio_length),"timeout")

	#fade out
	tween.interpolate_property(text_box, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.2, Tween.TRANS_LINEAR, 0)
	tween.start()
	yield(tween, "tween_completed")
	
	#clear text
	text_box.text = ""
