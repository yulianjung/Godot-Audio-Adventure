extends CanvasLayer

var can_exit = false

signal finished_color_fade
signal finished_image_fade
signal finished_title_fade
signal finished_subtitles_fade
signal transition_finished

onready var audio_controller = get_tree().get_current_scene().get_node("AudioController")
onready var titles = get_node("Control/ScreenAreasVBox/VBoxContainer4/Titles")
onready var subtitles = get_node("Control/ScreenAreasVBox/VBoxContainer6/Subtitles")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("dialogue_next"):
		if can_exit == true:
			endCutscene()
			

func hideAllElements():
	$Control/BackgroundRect.modulate = Color(1,1,1,0)
	$Control/ImageRect.modulate = Color(1,1,1,0)
	titles.modulate  = Color(1,1,1,0)
	titles.text = ""
	subtitles.modulate  = Color(1,1,1,0)
	subtitles.bbcode_text  = ""
	
	

#######################
# START AND END SCENES
#######################

func startCutscene():
	G.is_playing_cutscene = true
	hideAllElements()
	get_tree().paused = true
	audio_controller.pause_game_audio()
	titles.text = ""
	titles.modulate = Color(1,1,1,0)
	$Control.visible = true
	$AnimationPlayer.play_backwards("BlackBarsOut")
	
func endCutscene():
	G.is_playing_cutscene = false
	audio_controller.continue_game_audio()	
	stopNarration()
	stopFx()
	stopBackgroundAudio(3)
	$AnimationPlayer.stop()
	$ColorAnimationPlayer.stop()
	$ImageAnimationPlayer.stop()
	$TitleAnimationPlayer.stop()
	$SubtitleAnimationPlayer.stop()
	$EndSceneRectAnimationPlayer.play("Transition")
	yield(self, "transition_finished")
	#unpause
	get_tree().paused = false
	
	#remove cinema bars
	$AnimationPlayer.play("BlackBarsOut")



#######################
# AUDIO CONTROL
#######################

func playFx( sound ):
	if !G.is_playing_cutscene:
		return
		
	audio_controller.play_fx( sound )
	
func stopFx( fade_out = false, fade_out_duration = 3):
	audio_controller.stop_fx( fade_out, fade_out_duration )
	
# Plays audio and shows subtitle
func playNarration( audio_file, text, character_name ):
	if !G.is_playing_cutscene:
		return	

	#load up sound
	var audio_length
	var file = File.new()
	
	if not file.file_exists("res://Audio/Narration/" + audio_file):
		printerr("Could not find audio file: " + audio_file)
		return 0
	 
	if file.open("res://Audio/Narration/" + audio_file, File.READ) != OK:
		printerr("Could not open audio file: " + audio_file)
		return 0
	 
	var buffer = file.get_buffer(file.get_len())
	file.close()

#	Play OGG FILE
	var stream = AudioStreamOGGVorbis.new()
	stream.data = buffer

	var narrator = audio_controller.get_node("Narrator")
	narrator.stream = stream
	narrator.play()
	audio_length = stream.get_length()
	
	#add the character name to the subtitle
	subtitles.bbcode_text = "[center][b]"+ character_name +"[/b][/center]\n"
	
	#update the subtitle
	subtitles.bbcode_text += "[center]"+text+"[/center]"
	
	#fade in the subtitle
	$SubtitleAnimationPlayer.play("FadeIn")
	yield(get_tree().create_timer(audio_length),"timeout")
	$SubtitleAnimationPlayer.play_backwards("FadeIn")

	
func stopNarration():
	var narrator = audio_controller.get_node("Narrator")
	narrator.stop()


#play background audio
func playBackgroundAudio( sound_to_load, fade_in_length, loop = true ):
	if !G.is_playing_cutscene:
		return	
	
	if sound_to_load == null || sound_to_load == "":
		return

	#load our audio file

	#create a file container
	var file = File.new()

	#create link to audio file
	var audio_file = "res://Audio/Backgrounds/" + sound_to_load
	
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
	
	var background_audio_player = audio_controller.get_node("Cutscene_Background_Audio")
	background_audio_player.stream = stream
	background_audio_player.volume_db = -80
	background_audio_player.play()
	
	audio_controller.fade_in(background_audio_player, 0, 10)


#stop or fadeout background audio
func stopBackgroundAudio( fadeout_length ):
	
	var background_audio_player = audio_controller.get_node("Cutscene_Background_Audio")
	
	if background_audio_player.is_playing():
		audio_controller.fade_out(background_audio_player, 5)










#######################
# IMAGE CONTROL
#######################

#pass in texture to fade in and speed where 0.5 is half, 1.0 is normal and 2.0 is double
func fadeInImage( image_texture, speed = 1.0 ):
	#load in our image into a ImageTexture
	var new_image =  load("res://Assets/CutsceneImages/"+image_texture)
	
	#set our ImageRect to use our ImageTexture
	$Control/ImageRect.texture = new_image

	#$Control/ImageRect.set_texture ( load("res://Assets/CutsceneImages/"+image_texture) )
	
	#Set the speed of the animation
	$ImageAnimationPlayer.set_speed_scale(speed)
	
	#fade in the image
	$ImageAnimationPlayer.play("FadeIn")
	
func fadeOutImage():
	$ImageAnimationPlayer.play_backwards("FadeIn")



#######################
# COLOR CONTROL
#######################

func fadeInBlack():
	#set background rectangle to black and transparent
	$Control/BackgroundRect.color = Color(0,0,0)
	$ColorAnimationPlayer.play("FadeInBlack")

func fadeInWhite():
	#set background rectangle to black and transparent
	$Control/BackgroundRect.color = Color(1,1,1)
	$ColorAnimationPlayer.play("FadeInWhite")

func fadeOutBlack():
	#set background rectangle to black and transparent
	#$Control/BackgroundRect.color = Color(0,0,0)
	$ColorAnimationPlayer.play_backwards("FadeInBlack")

func fadeOutWhite():
	#set background rectangle to black and transparent
	#$Control/BackgroundRect.color = Color(0,0,0)
	$ColorAnimationPlayer.play_backwards("FadeInWhite")


#######################
# TITLES CONTROL
#######################

#Fades in title text, color is "black" or "white"
func fadeInTitle( text, color ):

	titles.text = text
	
	if color.to_lower() == "black":
		$TitleAnimationPlayer.play("FadeInBlack")
	else:
		$TitleAnimationPlayer.play("FadeInWhite")
	
#Fades out title text
func fadeOutTitle( color):

	if color.to_lower() == "black":
		$TitleAnimationPlayer.play_backwards("FadeInBlack")
	else:
		$TitleAnimationPlayer.play_backwards("FadeInWhite")
	








#######################
# ANIMATION SIGNAL EVENTS
#######################


func _on_AnimationPlayer_cinemabars_finished(anim_name: String) -> void:
	if can_exit == true:
		$Control.visible = false
		can_exit = false
	else:
		can_exit = true


func _on_ColorAnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("finished_color_fade")


func _on_ImageAnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("finished_image_fade")	


func _on_TitleAnimationPlayer_animation_finished(anim_name: String) -> void:
	print("finished title fadeout")
	emit_signal("finished_title_fade")	


func _on_EndSceneRectAnimationPlayer_animation_finished(anim_name: String) -> void:
	#print("finished transition")
	emit_signal("transition_finished")

#Triggered twice, start of narration and end of narration
func _on_SubtitleAnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("finished_subtitles_fade")
