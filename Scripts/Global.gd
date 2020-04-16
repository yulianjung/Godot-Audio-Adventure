extends Node

var play_narrative = false

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func update_gui():
	get_tree().get_current_scene().update_gui()

#Extracts the node name from an absolute node path
func extract_node( nodepath: NodePath ):
	#print ("Outputted " + nodepath.get_name( nodepath.get_name_count()-1 ))
	return nodepath.get_name( nodepath.get_name_count()-1 )
	
