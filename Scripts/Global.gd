extends Node

var play_narrative = false
var player_name = "Jove"

var talked_to_ai = false

func player():
	return MSG.level_root().get_node("main/Player")

#
#func show_fireworks():
#	MSG.level_root().get_node("fireworks").emitting = true
#	yield(MSG.time(2), "timeout")
#	MSG.level_root().get_node("fireworks").emitting = false




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func update_gui():
	get_tree().get_current_scene().update_gui()


#Extracts the node name from an absolute node path
func extract_node( nodepath: NodePath ):
	#print ("Outputted " + nodepath.get_name( nodepath.get_name_count()-1 ))
	return nodepath.get_name( nodepath.get_name_count()-1 )
	
