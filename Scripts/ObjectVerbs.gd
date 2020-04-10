extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var audio_controller = get_tree().get_current_scene().get_node("AudioController")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func Object_Picture(verb):
	
	match verb.to_lower():
		"smash":
			audio_controller.queue_narration( "I picked up the picture frame and threw it against the wall, damn it, why did he have to leave", "object_picture_smash.ogg" )
			print("You smash the picture frame!")
		"examine":
			audio_controller.queue_narration( "It's a picture of me and my father, we were going for a stroll!", "object_picture_examine.ogg" )
			print("It's a picture of me and my father, we were going for a stroll!")

