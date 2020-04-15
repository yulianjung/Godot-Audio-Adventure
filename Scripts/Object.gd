extends Node

var instancename = "object"

export var visible = true
export var button_text = ""
export var item = false
export (Texture) var object_image
export (NodePath) var target_exit #used when an object can take you to a location i.e. a lift button
export var verbs = ["","","","","",""]

onready var target_exit_node = get_node(target_exit)

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass



#Add a verb to the object, if at is not -1 then it will overide existing index at the location selected
func add_verb(verb_name, at = -1):
	var index = 0
	
	
	#look for the from verb in our list of verbs
	for verb in verbs:
		
		#If we want to overwrite a particular verb index, then do it
		if index == at:
			self.verbs[index] = verb_name
			get_tree().get_current_scene().update_gui()
			return true
			
		#otherwise inject it in the closest blank spot
		if verb == "":
			self.verbs[index] = verb_name
			get_tree().get_current_scene().update_gui()
			return true
			
		index += 1
	
	#if we made it this far, we didn't update anything
	return false



#Add a verb to the object, if at is not -1 then it will overide existing index at the location selected
func remove_verb(verb_name):
	var index = 0

	#look for the  verb in our list of verbs
	for verb in verbs:
		
		if verb.to_lower() == verb_name.to_lower():
			#remove the verb
			self.verbs[index] = ""
			get_tree().get_current_scene().update_gui()
			return true
		
		index += 1
	
	#if we made it this far, we didn't update anything
	return false




#change a verb from to
func change_verb(from, to):
	var index = 0
	
	#look for the from verb in our list of verbs
	for verb in verbs:
		if verb.to_lower() == from.to_lower():
			#change the from verb to our to verb
			self.verbs[index] = to
			get_tree().get_current_scene().update_gui()
			return true
		index += 1
	
	#if we made it this far, we didn't update anything
	return false
