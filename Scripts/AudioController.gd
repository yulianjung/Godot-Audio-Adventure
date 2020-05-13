extends Node

onready var tween_in = get_node("TweenIn")
onready var tween_out = get_node("TweenOut")
onready var tween_out_pause = get_node("TweenOutPause")
onready var player = get_tree().get_current_scene().get_node("Player")
onready var game = get_tree().get_current_scene()
onready var spacialiser = AudioServer.get_bus_effect_instance(1,0)
export var audio_transition_fadein_duration = 1.00
export var audio_transition_fadeout_duration = 1.00
export var audio_transition_type = 1 # TRANS_SINE

export var default_npc_transition_volume = 0

signal finished_playing_fx
signal finished_playing_narration
signal npc_transition_finished

var location_player
var location_audio_paused_at

var inspector = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print ( AudioServer.get_bus_effect_instance(1,0).get_room_size())
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass


func play_npc_transition( sound_to_load, fade = null):
	
	#load the sound
	if sound_to_load == null || sound_to_load == "":
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
	
	#add a streamplayer to AudioController
	var transition_stream_player = AudioStreamPlayer.new()
	add_child(transition_stream_player)
	transition_stream_player.volume_db = default_npc_transition_volume
	
	var tween = Tween.new()
	
	#may add a tween based on fade condition in/out
	if fade != null and fade.to_lower() == "in":
		transition_stream_player.volume_db = -80
		tween.interpolate_property(transition_stream_player, "volume_db", -80, default_npc_transition_volume, stream.get_length(), audio_transition_type, Tween.EASE_OUT, 0)
		add_child(tween)
		tween.start()
		
	if fade != null and fade.to_lower() == "out":
		transition_stream_player.volume_db = default_npc_transition_volume
		tween.interpolate_property(transition_stream_player, "volume_db", default_npc_transition_volume, -80, stream.get_length(), audio_transition_type, Tween.EASE_OUT, 0)
		add_child(tween)
		tween.start()
	
	transition_stream_player.stream = stream
	transition_stream_player.play()
	
	yield(get_tree().create_timer( stream.get_length()+1 ), "timeout")
	
	#delete streamplayer and tween on signal complete
	transition_stream_player.queue_free()
	tween.queue_free()

#	if (fade.to_lower() == "in"):
#	$TransitionAudio.stream
#
#	var tween = Tween.new()
#	tween.interpolate_property(sprite, 'transform/scale', sprite.get_scale(), Vector2(2.0, 2.0), 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)	


#Plays the exit or arrival audio for a location, it returns the length of the audio so it can queue the next file i.e. plays exit then arrive
#fade can be in or out
func play_location_transition( sound_to_load):
	
	if sound_to_load == null || sound_to_load == "":
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



#called when location is changed, transitions from one background audio to another
#audio is target audio stream to fade in
func background_audio_transition( audiostream, volume ):

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

		
	#check to see if new location has an audio background
	#if it does, the start fading it in
	audiostream.set_loop(true)
	fadein_audio.set_stream(audiostream)
	fadein_audio.set_volume_db(-80)
	fadein_audio.play( player.get_current_location_object().current_audio_position )
	#print(player.get_current_location_node(), ":Continuing play back from ", player.get_current_location_object().current_audio_position)
	fade_in(fadein_audio, volume)
	fade_out(fadeout_audio)



func fade_in(stream_player, volume, length = audio_transition_fadein_duration):
	# tween audio volume up to 0 (normal or selected volume)
	tween_in.interpolate_property(stream_player, "volume_db", -80, volume, length, audio_transition_type, Tween.EASE_OUT, 0)
	tween_in.start()


func fade_out(stream_player, length = audio_transition_fadeout_duration):
	
	#get current volume of stream
	var current_volume = stream_player.volume_db
	
	# tween volume down to -80db
	tween_out.interpolate_property(stream_player, "volume_db", current_volume, -80, length, audio_transition_type, Tween.EASE_OUT, 0)
	tween_out.start()
	# when the tween ends, the sound will stop
	
	
#Used for Tweening out Location Audio when transitioning, it can save the current state
func _on_TweenOut_tween_completed(object: Object, key: NodePath) -> void:
	# stop the audio -- otherwise it continues to run at silent volume
	
	if player.get_previous_location_object().always_restart_bg_audio == false:
		player.get_previous_location_object().current_audio_position = object.get_playback_position()
		#print (player.get_previous_location_node(), ": Saving time code ", player.get_previous_location_object().current_audio_position)
	
	object.stop()



#pass in Background audio .ogg filename
func change_background_audio( audio, permanent = true ):

	var target_audio

	if audio == null:
		return
	#load our audio file
	
	#create a file container
	var file = File.new()
	
	#create link to audio file
	var audio_file = "res://Audio/Backgrounds/" + audio
	
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
	stream.set_loop(true)
	
	#decide which channel fades in and which channel fades out	
	if ($Location_Background_Audio.is_playing()):
		target_audio = $Location_Background_Audio
	else:
		target_audio = $Location_Background_Audio2

	#set audio stream
	target_audio.stream = stream
	
	#update volume for this location
	target_audio.set_volume_db( player.get_current_location_object().background_audio_volume_db )

	#update objects audio permanantly
	if permanent == true:
		player.get_current_location_object().background_audio = stream

	#play audio
	target_audio.play()








	



# Queue Audio Narrator to play audio and display associated text copy
func queue_narration( text, audio, save_to_log = false ):
	
	var audio_length = 0
	
	#get a link to the current text box
	var text_box = get_tree().get_current_scene().get_node("UserInterface/HBoxContainer/MainScreen-Container/LocationImage/ImageOverlay/BottomOverlay/ColorRect/Narrative")
	var tween = get_tree().get_current_scene().get_node("UserInterface/Tween")
	text_box.text = text
	
	#update audio log
	if save_to_log == true:
		game.audio_log.append( {"Location": player.get_current_location_object().location_name, "Announcer":"Narrator", "Text": text} )
	
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
		if G.play_narrative == true:
			$Narrator.play()
	else:
	
		#get the length of the audio to play
		audio_length = audio.get_length()
		
		$Narrator.set_stream(audio)
		if G.play_narrative == true:
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




#Plays a sound audio file
func play_fx( sound_to_load ):
	
	if sound_to_load == null:
		return
	#load our audio file
	
	#create a file container
	var file = File.new()
	
	#create link to audio file
	var audio_file = "res://Audio/FX/" + sound_to_load
	
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
	
	$SoundFX.stream = stream
	$SoundFX.play()

	return stream.get_length()


#Stops FX 
func stop_fx( fade_out = false, fade_out_duration = 3 ):
	
	if fade_out == false:
		$SoundFX.stop()
	else:
		tween_out.interpolate_property($SoundFX, "volume_db", 0, -80, fade_out_duration, audio_transition_type, Tween.EASE_OUT, 0)
		tween_out.start()










# Pauses audio for a cutscene
func pause_game_audio():

	#fadeout to zero
	if $Location_Background_Audio.is_playing():
		location_player = $Location_Background_Audio
		fade_out_game_location($Location_Background_Audio)
		
	if $Location_Background_Audio2.is_playing():
		location_player = $Location_Background_Audio2
		fade_out_game_location($Location_Background_Audio2)
	
#continues audio after a cutscene
func continue_game_audio():
	#fades in last scene's background audio and volume
	tween_in.stop( $Cutscene_Background_Audio )
	tween_out.stop( $Cutscene_Background_Audio )
	tween_out_pause.stop( $Cutscene_Background_Audio )
	location_player.play( location_audio_paused_at )
	fade_in(location_player, player.get_current_location_object().background_audio_volume_db )
	
	
func fade_out_game_location(stream_player):
	# tween volume down to -80db
	tween_out_pause.interpolate_property(stream_player, "volume_db", 0, -80, audio_transition_fadeout_duration, audio_transition_type, Tween.EASE_OUT, 0)
	tween_out_pause.start()
	
#Used for Tweening out Location Audio when pausing
func _on_TweenOutPause_tween_completed(object: Object, key: NodePath) -> void:
	
	print("finished fade out at ",object.get_playback_position())
	location_audio_paused_at = object.get_playback_position()
	
	object.stop()




# emit a signal when sound effect finish
func _on_SoundFX_finished() -> void:
	emit_signal("finished_playing_fx")


func _on_Narrator_finished() -> void:
	emit_signal("finished_playing_narration")
	pass # Replace with function body.
