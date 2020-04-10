extends Node

onready var tween_in = get_node("TweenIn")
onready var tween_out = get_node("TweenOut")
export var audio_transition_fadein_duration = 3.00
export var audio_transition_fadeout_duration = 3.00
export var audio_transition_type = 1 # TRANS_SINE


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if ($Location_Background_Audio.volume_db):
		pass
		#print("BUS 1:"+str($Location_Background_Audio.volume_db))
	if ($Location_Background_Audio2.volume_db):
		pass
		#print("BUS 2:"+str($Location_Background_Audio2.volume_db))
	

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
	


func play_location_transition( sound_to_load ):
	
	if sound_to_load == null:
		return
	#load our audio file
	
	#create file name
	var sound = "transition-" + sound_to_load + ".ogg"
	
	#create a file container
	var file = File.new()
	
	#create link to audio file
	var audio_file = "res://Audio/Transitions/" + sound
	
	if not file.file_exists(audio_file):
		printerr("Could not find audio file: " + audio_file)
		return
		
	if file.open(audio_file, File.READ) != OK:
		printerr("Could not open audio file: " + audio_file)
		return
	 
	var buffer = file.get_buffer(file.get_len())
	file.close()
	
	var stream = AudioStreamOGGVorbis.new()
	stream.data = buffer
	
	$TransitionAudio.stream = stream
	$TransitionAudio.play()

	return stream.get_length()



func fade_in(stream_player, volume):
	# tween music volume up to 0 (normal or selected volume)
	tween_in.interpolate_property(stream_player, "volume_db", -80, volume, audio_transition_fadein_duration, audio_transition_type, Tween.EASE_OUT, 0)
	tween_in.start()


func fade_out(stream_player):
	# tween volume down to -80db
	tween_out.interpolate_property(stream_player, "volume_db", 0, -80, audio_transition_fadeout_duration, audio_transition_type, Tween.EASE_OUT, 0)
	tween_out.start()
	# when the tween ends, the sound will stop
	

func _on_TweenOut_tween_completed(object: Object, key: NodePath) -> void:
	# stop the music -- otherwise it continues to run at silent volume
	object.stop()





# Queue Audio Narrator to play audio and display associated text copy
func queue_narration( text, audio ):
	
	var audio_length = 0
	
	#get a link to the current text box
	var text_box = get_tree().get_current_scene().get_node("UserInterface/HBoxContainer/MainScreen-Container/LocationImage/ImageOverlay/BottomOverlay/ColorRect/Narrative")
	var tween = get_tree().get_current_scene().get_node("UserInterface/Tween")
	text_box.text = text
	
	#is the audio a string or a preloaded script
	if typeof(audio) == 4: #this is a string, load the narration dynamically
		#Load Audio File
		
		#create a file container
		var file = File.new()
		#create link to audio file
		var audio_file = "res://Audio/Narration/" + audio
		
		if not file.file_exists(audio_file):
			printerr("Could not find audio file: " + audio_file)
			return
			
		if file.open(audio_file, File.READ) != OK:
			printerr("Could not open audio file: " + audio_file)
			return
		 
		var buffer = file.get_buffer(file.get_len())
		file.close()
		
		var stream = AudioStreamOGGVorbis.new()
		stream.data = buffer
		
		audio_length = stream.get_length()
		
		$Narrator.stream = stream
		$Narrator.play()
	else:
	
		#get the length of the audio to play
		audio_length = audio.get_length()
		
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
