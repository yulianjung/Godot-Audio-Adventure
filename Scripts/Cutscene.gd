extends CanvasLayer

var can_exit = false

signal finished_color_fade
signal finished_image_fade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("dialogue_next"):
		if can_exit == true:
			end_cutscene()


func start_cutscene():
	get_tree().paused = true
	$Control.visible = true
	$AnimationPlayer.play_backwards("BlackBarsOut")
	
func end_cutscene():
	get_tree().paused = false
	$AnimationPlayer.play("BlackBarsOut")
	fadeOutColor()

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
	$ColorAnimationPlayer.play("FadeIn")

func fadeInWhite():
	#set background rectangle to black and transparent
	$Control/BackgroundRect.color = Color(1,1,1)
	$ColorAnimationPlayer.play("FadeIn")

func fadeOutColor():
	#set background rectangle to black and transparent
	#$Control/BackgroundRect.color = Color(0,0,0)
	$ColorAnimationPlayer.play_backwards("FadeIn")


func _on_AnimationPlayer_cinemabars_finished(anim_name: String) -> void:
	if can_exit == true:
		$Control.visible = false
		can_exit = false
	else:
		can_exit = true


func _on_ColorAnimationPlayer_animation_finished(anim_name: String) -> void:
	print("We finished the color animation")
	emit_signal("finished_color_fade")
	pass # Replace with function body.


func _on_ImageAnimationPlayer_animation_finished(anim_name: String) -> void:
	print("We finished the image animation")
	emit_signal("finished_image_fade")	
	pass # Replace with function body.
