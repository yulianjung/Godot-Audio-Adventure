extends Node2D


func _ready() -> void:
	update_gui()
	$Player.change_location( NodePath("Quarters"), "none", "none" )


#MAIN INPUT LOOP
# warning-ignore:unused_argument
func _process(delta: float) -> void:
	pass




# UPDATES THE USER INTERFACE
func update_gui():

	#update current location image
	get_node("UserInterface/HBoxContainer/MainScreen-Container/LocationImage").texture = get_tree().get_current_scene().get_node($Player.get_location()).bg_image
	#update current location text
	get_node("UserInterface/HBoxContainer/MainScreen-Container/LocationImage/ImageOverlay/TopOverlay/Location").text = get_node($Player.get_location()).location_name 
	
	#Update list of exit buttons
	display_exits()
	
	
	
	
# Displays list of exits as buttons (NEEDS EVENTS HOOKED UP)
func display_exits():

	#create link to current location
	var location_node = get_node($Player.get_location())

	#remove all the old exits
	for buttons in get_tree().get_nodes_in_group("exits"):
		buttons.queue_free()
	
	#add exit buttons dyamically to GUI
	var row_y = 0
	for exit in location_node.get_children():
		
		#if target location is not set, crash out and flag the error
		if (exit.target_location == null):
			print("ERROR: No target location set for exit " + exit.name)
			Engine.get_main_loop().finish()

		var button = Button.new()
		#button.group = "exits"
		button.add_to_group("exits")
		button.text = exit.button_text #the display string shown on the button

		#DO WE ALLOW TO PROCEED? TO DO
		button.connect("pressed", self, "_on_Button_button_up", [exit.target_location, exit.exit_audio, exit.arrival_audio ]) #action when button released, jump to target location
		#position button appropriatley
		row_y += 30
		button.rect_position.y = row_y
		get_node("UserInterface/HBoxContainer/Interface-Container").add_child(button) # Add the exit button the User Interface
	

#When button has been pressed trigger location change and update GUI
func _on_Button_button_up( target_location, transition_audio, arrival_audio ) -> void:
		
	$Player.change_location(target_location,transition_audio, arrival_audio)
	update_gui()
	pass # Replace with function body.

