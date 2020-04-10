extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func Object_Picture(verb):
	
	match verb.to_lower():
		"smash":
			print("You smash the picture frame!")
		"examine":
			print("It's a picture of me and my father, we were going for a stroll!")

