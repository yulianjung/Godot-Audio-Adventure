extends Node

class_name Item, "res://Assets/Icons/item.png"

export var visible = true
export var button_text = ""
export var item = false
export (Texture) var object_image
export (NodePath) var target_exit #used when an object can take you to a location i.e. a lift button
export var verbs = ["","","","","",""]
var target_exit_node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#If target_exit is set for an object then get the node
	if target_exit != null && target_exit != "":
		self.target_exit_node = get_node(target_exit)


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
	
	
# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	add_to_group("items")
	
func _exit_tree() -> void:
	remove_from_group("items")
	
