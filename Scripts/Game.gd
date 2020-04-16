extends Node2D

var audio_log = [ {"Location":"", "Announcer":"", "Text":""} ]


func _ready() -> void:
	update_gui()
	$Player.use_exit( get_node("Balcony/Exit_Living_Area") ) # 


#MAIN INPUT LOOP
# warning-ignore:unused_argument
func _process(delta: float) -> void:
	pass




# UPDATES THE USER INTERFACE
func update_gui():

	#update current location image
	get_node("UserInterface/HBoxContainer/MainScreen-Container/LocationImage").texture = get_tree().get_current_scene().get_node($Player.get_current_location_node()).bg_image
	#update current location text
	get_node("UserInterface/HBoxContainer/MainScreen-Container/LocationImage/ImageOverlay/TopOverlay/Location").text = get_node($Player.get_current_location_node()).location_name 
	
	#Update list of exit buttons
	display_exits()
	
	#display objects
	display_objects()
	
	



# Displays list of objects as buttons
func display_objects():
	#create link to current location
	var location_node = get_node($Player.get_current_location_node())
#
#	#remove all the old objects
	for buttons in get_tree().get_nodes_in_group("objects"):
		buttons.queue_free()
#
#	#add exit buttons dyamically to GUI
	var row_y = 0
	for object in location_node.get_children():

		#only process object instances
		if object.instancename != "object":
			continue
			
		#don't show invisible objects
		if object.visible == false:
			continue
		
		var button = MenuButton.new()
		#button.group = "exits"
		button.add_to_group("objects")
		button.text = object.button_text #the display string shown on the button
		button.flat = false
		
		#LOOP THROUGH BUTTON VERBS / ACTIONS AND ADD TO POPUPMENU
		for verb in object.verbs:
			#if verb not set then skip
			if verb == "":
				continue
			button.get_popup().add_item(verb)
			button.get_popup().connect("id_pressed", self, "_on_item_pressed", [object, button])
			
	

		#button.connect("pressed", self, "_on_Button_button_up", [exit.target_location, exit.exit_audio, exit.arrival_audio ]) #action when button released, jump to target location
		
		#position button appropriatley
		row_y += 30
		button.rect_position.y = row_y
		get_node("UserInterface/HBoxContainer/Interface-Container/Objects").add_child(button) # Add the exit button the User Interface
		



func _on_item_pressed(id, object, button):
	var object_name = object.name
	var option_pressed = button.get_popup().get_item_text(id)
	
	#check for post exit method (called after the player arrives)
	var object_func_name = object_name.to_lower()
	
	if GameScript.has_method(object_func_name):
		GameScript.call(object_func_name, option_pressed, object) #dynamically call method in GameScript script.
	else:
		print("Couldn't find a script for object ",object_func_name, " with verb ",option_pressed)

	
	
	
# Displays list of exits as buttons
func display_exits():

	#create link to current location
	var location_node = get_node($Player.get_current_location_node())

	#remove all the old exits
	for buttons in get_tree().get_nodes_in_group("exits"):
		buttons.queue_free()
	
	#add exit buttons dyamically to GUI
	var row_y = 0
	for exit in location_node.get_children():
		
		#only process exit instances
		if exit.instancename != "exit":
			continue
			
		#don't show invisible exits
		if exit.visible == false:
			continue			
		
		#if target location is not set, crash out and flag the error
		if (exit.target_location == null):
			print("ERROR: No target location set for exit " + exit.name)
			Engine.get_main_loop().finish()

		var button = Button.new()
		#button.group = "exits"
		button.add_to_group("exits")
		button.text = exit.button_text #the display string shown on the button

		#DO WE ALLOW TO PROCEED? TO DO
		button.connect("pressed", self, "_on_Button_button_up", [ exit ]) #action when button released, pass through given exit
		#position button appropriatley
		row_y += 30
		button.rect_position.y = row_y
		get_node("UserInterface/HBoxContainer/Interface-Container/Locations").add_child(button) # Add the exit button the User Interface
	

#When button has been pressed trigger location change and update GUI
func _on_Button_button_up( exit ) -> void:

	#Is the player allowed to take the exit
	var allowed = true

	#check for pre exit method (called before allowing the player to exit)
	var pre_exit_func_name = ("pre_"+exit.name)
	pre_exit_func_name = pre_exit_func_name.to_lower()

	if GameScript.has_method(pre_exit_func_name):
		allowed = GameScript.call(pre_exit_func_name, exit) #dynamically call method in GameScript script.

	# if the player is allowed to exit then continue
	if allowed != false:
		$Player.use_exit(exit)
		update_gui()

		#check for post exit method (called after the player arrives)
		var post_exit_func_name = ("post_"+exit.name)
		post_exit_func_name = post_exit_func_name.to_lower()
	
		if GameScript.has_method(post_exit_func_name):
			GameScript.call(post_exit_func_name, exit) #dynamically call method in GameScript script.

