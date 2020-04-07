extends Node


#List of all transition audio files
enum TRANSITION_AUDIO { 
	none,
	footsteps_indoors,
	footsteps_outside,
	enter_lift,
	exit_lift,
	lift_change_floor,
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass



#
#func list_files_in_directory(path):
#	var files = []
#	var dir = Directory.new()
#	dir.open(path)
#	dir.list_dir_begin()
#
#	while true:
#		var file = dir.get_next()
#		if file == "":
#			break
#		elif not file.begins_with("."):
#			files.append(file)
#
#	dir.list_dir_end()
#
#	return files


