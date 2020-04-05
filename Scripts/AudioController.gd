extends Node

onready var tween_in = get_node("TweenIn")
onready var tween_out = get_node("TweenOut")
export var audio_transition_fadein_duration = 3.00
export var audio_transition_fadeout_duration = 3.00
export var audio_transition_type = 1 # TRANS_SINE


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


#called when location is changed, transitions from one background audio to another
#audio is target audio stream to fade in
func audio_transition( audiostream, volume ):

	#check to see if any audio is currently playing
	var fadein_audio
	var fadeout_audio

	#decide which channel fades in and which channel fades out	
	if ($Location_Background_Audio.is_playing()):
		fadein_audio = $Location_Background_Audio2
		fadeout_audio = $Location_Background_Audio
	else:
		fadein_audio = $Location_Background_Audio
		fadeout_audio = $Location_Background_Audio2

	#TEMPORARY / DELETE
	#fadein_audio.stop()
	#fadeout_audio.stop()
	#fade_out(fadeout_audio)
	
		
	#check to see if new location has an audio background
	#if it does, the start fading it in
	audiostream.set_loop(true)
	fadein_audio.set_stream(audiostream)
	fadein_audio.set_volume_db(-80)
	fadein_audio.play()
	fade_in(fadein_audio, volume)
	fade_out(fadeout_audio)
	

	#queue any transition sound
	
	



func fade_in(stream_player, volume):
	# tween music volume down to 0
	tween_in.interpolate_property(stream_player, "volume_db", -80, volume, audio_transition_fadein_duration, audio_transition_type, Tween.EASE_IN, 0)
	tween_in.start()
	# when the tween ends, the music will be stopped


func fade_out(stream_player):
	# tween music volume down to 0
	tween_out.interpolate_property(stream_player, "volume_db", 0, -80, audio_transition_fadeout_duration, audio_transition_type, Tween.EASE_IN, 0)
	tween_out.start()
	# when the tween ends, the music will be stopped
	

func _on_TweenOut_tween_completed(object: Object, key: NodePath) -> void:
	# stop the music -- otherwise it continues to run at silent volume
	object.stop()





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
		
	#delay depending on number passed in (usually the length of time the seconds the audio lasts)
	yield(get_tree().create_timer(audio_length),"timeout")

	#fade out
	tween.interpolate_property(text_box, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.2, Tween.TRANS_LINEAR, 0)
	tween.start()
	yield(tween, "tween_completed")
	
	#clear text
	text_box.text = ""
