extends Node2D


func _ready() -> void:
	update_gui()



#MAIN INPUT LOOP
func _process(delta: float) -> void:
	
	#create link to current location
	var location_node = get_node($Player.current_location)

	#display exits
	var count = 0
	for exit in location_node.exits:
		if (count == 0):
			print("LEFT FOR "+exit)
			if Input.is_action_just_released("ui_left"):
				$Player.change_location(exit)
				update_gui()
				print(location_node.introduction)
		if (count == 1):
			print("UP FOR "+exit)
			if Input.is_action_just_released("ui_up"):
				$Player.change_location(exit)
				update_gui()
				print(location_node.introduction)
		if (count == 2):
			print("RIGHT FOR "+exit)
			if Input.is_action_just_released("ui_right"):
				$Player.change_location(exit)
				update_gui()
				print(location_node.introduction)
		count = count + 1




# UPDATES THE USER INTERFACE
func update_gui():
	#update current location
	$UserInterface/LocationValue.text = $Player.current_location 
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
		#position button appropriatley
		row_y += 30
		button.rect_position.y = row_y
		$UserInterface.add_child(button)
	
