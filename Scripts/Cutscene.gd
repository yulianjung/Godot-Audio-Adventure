extends CanvasLayer

var can_exit = false

signal finished_color_fade
signal finished_image_fade
signal finished_title_fade
signal finished_narration_fade
signal transition_finished


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("dialogue_next"):
		if can_exit == true:
			end_cutscene()

func hideAllElements():
	$Control/BackgroundRect.modulate = Color(1,1,1,0)
	$Control/ImageRect.modulate = Color(1,1,1,0)
	$Control/ScreenAreasVBox/VBoxContainer3/Titles.modulate  = Color(1,1,1,0)
	$Control/ScreenAreasVBox/VBoxContainer4/Narration.modulate  = Color(1,1,1,0)


func start_cutscene():
	get_tree().paused = true
	$Control/ScreenAreasVBox/VBoxContainer3/Titles.text = ""
	$Control/ScreenAreasVBox/VBoxContainer3/Titles.modulate = Color(1,1,1,0)
	$Control.visible = true
	$AnimationPlayer.play_backwards("BlackBarsOut")
	
func end_cutscene():
	
	$EndSceneRectAnimationPlayer.play("Transition")
	yield(self, "transition_finished")
	#unpause
	get_tree().paused = false
	
	#remove cinema bars
	$AnimationPlayer.play("BlackBarsOut")

#pass in texture to fade in
func fadeInImage( image_texture ):
	#load in our image into a ImageTexture
	var new_image =  load("res://Assets/CutsceneImages/"+image_texture)
	
	#set our ImageRect to use our ImageTexture
	$Control/ImageRect.texture = new_image

	#$Control/ImageRect.set_texture ( load("res://Assets/CutsceneImages/"+image_texture) )
	
	#fade in the image
	$ImageAnimationPlayer.play("FadeIn")
	
func fadeOutImage():
	$ImageAnimationPlayer.play_backwards("FadeIn")

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


#Fades in title text, color is "black" or "white"
func fadeInTitle( text, color ):
	$Control/ScreenAreasVBox/VBoxContainer3/Titles.text = text
	#$Control/ScreenAreasVBox/VBoxContainer3/Titles.modulate = color
	if color.to_lower() == "black":
		$TitleAnimationPlayer.play("FadeInBlack")
	else:
		$TitleAnimationPlayer.play("FadeInWhite")
	
#Fades out title text
func fadeOutTitle( text, color):
	#$Control/ScreenAreasVBox/VBoxContainer3/Titles.modulate = color
	if color.to_lower() == "black":
		$TitleAnimationPlayer.play_backwards("FadeOutBlack")
	else:
		$TitleAnimationPlayer.play_backwards("FadeOutWhite")
	

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
	emit_signal("finished_title_fade")	


func _on_EndSceneRectAnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("transition_finished")

