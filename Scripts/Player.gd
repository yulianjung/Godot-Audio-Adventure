extends Node

export var player_name = ''
export var current_location = 'Quarters'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func change_location( location ):
	
	#is this a valid location (TO DO)
	current_location = location
	pass
	
