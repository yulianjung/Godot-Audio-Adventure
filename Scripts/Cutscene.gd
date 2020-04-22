extends CanvasLayer

var can_exit = false
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


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
	print("WE STARTED")
	pass
	
func end_cutscene():
	get_tree().paused = false
	$AnimationPlayer.play("BlackBarsOut")
	print("WE FINISHED")
	pass
	
	


func _on_AnimationPlayer_cinemabars_finished(anim_name: String) -> void:
	if can_exit == true:
		$Control.visible = false
		can_exit = false
	else:
		can_exit = true
