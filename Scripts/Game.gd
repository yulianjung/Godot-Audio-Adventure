extends Node2D


func _ready() -> void:
	update_gui()
	$Player.change_location("Quarters")


#MAIN INPUT LOOP
# warning-ignore:unused_argument
func _process(delta: float) -> void:
	
	#create link to current location
	var location_node = get_node($Player.current_location)

	#display exits




# UPDATES THE USER INTERFACE
func update_gui():
	#update current location image
	get_node("UserInterface/HBoxContainer/MainScreen-Container/LocationImage").texture = get_node($Player.current_location).bg_image
	#update current location text
	get_node("UserInterface/HBoxContainer/MainScreen-Container/LocationImage/ImageOverlay/TopOverlay/Location").text = $Player.current_location 
	display_exits()
	
	
	
	
# Displays list of exits as buttons (NEEDS EVENTS HOOKED UP)
func display_exits():

	#create link to current location
	var location_node = get_node($Player.current_location)

	#remove all the old exits
	for buttons in get_tree().get_nodes_in_group("exits"):
		buttons.queue_free()
	
	#add new exits
	var row_y = 0
	for exit in location_node.exits:
		var button = Button.new()
		#button.group = "exits"
		button.add_to_group("exits")
		button.text = exit
		button.connect("pressed", self, "_on_Button_button_up", [exit])
		#position button appropriatley
		row_y += 30
		button.rect_position.y = row_y
		get_node("UserInterface/HBoxContainer/Interface-Container").add_child(button)
	


func _on_Button_button_up( target_location ) -> void:
	$Player.change_location(target_location)
	update_gui()
	pass # Replace with function body.
