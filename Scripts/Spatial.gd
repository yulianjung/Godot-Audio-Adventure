extends Spatial



onready var camera = $Camera

var mouse_sens = 0.01
var camera_anglev=0
var x_change
var label_offset_y = 60

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(cube.translation.x)
	#cube.rotate_x(PI)
	#cube.rotate_object_local(Vector3(0, 1, 0), PI)
	$MeshInstance.rotate_object_local(Vector3(0, 1, 0), delta*PI)
	$MeshInstance.rotate_object_local(Vector3(1, 0, 0), delta*PI)
	$MeshInstance.rotate_object_local(Vector3(0, 0, 1), delta*PI)
	
	$MeshInstance2.rotate_object_local(Vector3(1, 0, 0), delta*PI)
	$MeshInstance2.rotate_object_local(Vector3(0, 1, 0), delta*PI)
	$MeshInstance2.rotate_object_local(Vector3(0, 0, 1), delta*PI)
	
	$MeshInstance3.rotate_object_local(Vector3(0, 0, 1), delta*PI)
	$MeshInstance3.rotate_object_local(Vector3(0, 1, 0), delta*PI)
	$MeshInstance3.rotate_object_local(Vector3(1, 0, 0), delta*PI)
	
	$MeshInstance4.rotate_object_local(Vector3(0, 0, 1), delta*PI)
	$MeshInstance4.rotate_object_local(Vector3(1, 0, 0), delta*PI)
	$MeshInstance4.rotate_object_local(Vector3(0, 1, 0), delta*PI)
	
	$MeshInstance5.rotate_object_local(Vector3(0, 0, 1), delta*PI)
	$MeshInstance6.rotate_object_local(Vector3(1, 0, 0), delta*PI)
	$MeshInstance7.rotate_object_local(Vector3(0, 1, 0), delta*PI)
	

func _input(event):         
	
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position)
	
	if event is InputEventMouseMotion:
		x_change = -event.relative.x*mouse_sens

		#check if mouse over object
		check_hover(event.position)
		
		#Update label positions
		float_labels()
		
		
		#print("Mesh XY: ", camera.unproject_position($MeshInstance.translation) )
		#print("Mous XY: ", $CanvasLayer.get_global_mouse_pos() )
		
#		print("Camera Rotation: ",camera.rotation_degrees.y)
#		print("MOUSE X: ",-event.relative.x)
#		print ("CHANGE: ",x_change)

		camera.rotate_y(deg2rad(x_change))
		
		#Check left side
		if (camera.rotation_degrees.y < -5):
			camera.rotation_degrees.y = -5
		
		if (camera.rotation_degrees.y + x_change > 5):
			camera.rotation_degrees.y = 5
		
		#var changev=-event.relative.y*mouse_sens
		#if camera_anglev+changev>-50 and camera_anglev+changev<50:
		#	camera_anglev+=changev
		#	camera.rotate_x(deg2rad(changev))


func check_hover( mouse_xy ):
	
	var collision = false
	
	#loop through objects
	for cube in get_tree().get_nodes_in_group("Cube"):
		collision = check_collision( mouse_xy, cube, 30)
		
		if collision:
			cube.scale = Vector3(0.3,0.3,0.3)
		else:
			cube.scale = Vector3(0.2,0.2,0.2)
	
	
	

#checks for a collecition between mouse_xy and object_translation based on a given raidus around the object
func check_collision( mouse_xy: Vector2, target_object, radius):

	var object_viewport_xy = camera.unproject_position(target_object.translation)

	var circle1 = {"radius": 1, "x": mouse_xy.x, "y": mouse_xy.y}
	var circle2 = {"radius": radius, "x": object_viewport_xy.x, "y": object_viewport_xy.y}
	
	var dx = circle1.x - circle2.x
	var dy = circle1.y - circle2.y
	var distance = sqrt(dx * dx + dy * dy)
	
	if (distance < circle1.radius + circle2.radius):
		return true
	
	return false
	
# Displays list of exits as buttons
#func display_exits():
#
#	#create link to current location
#	var location_node = get_node($Player.get_current_location_node())
#
#	#remove all the old exits
#	for buttons in get_tree().get_nodes_in_group("exits"):
#		buttons.queue_free()
#
#	#add exit buttons dyamically to GUI
#	var row_y = 0
#	for exit in location_node.get_children():
#
#		#only process exit instances
#		if exit.instancename != "exit":
#			continue
#
#		#don't show invisible exits
#		if exit.visible == false:
#			continue			
#
#		#if target location is not set, crash out and flag the error
#		if (exit.target_location == null):
#			print("ERROR: No target location set for exit " + exit.name)
#			Engine.get_main_loop().finish()
#
#		var button = Button.new()
#		#button.group = "exits"
#		button.add_to_group("exits")
#		button.text = exit.button_text #the display string shown on the button
#
#		#DO WE ALLOW TO PROCEED? TO DO
#		button.connect("pressed", self, "_on_Button_button_up", [ exit ]) #action when button released, pass through given exit
#		#position button appropriatley
#		row_y += 30
#		button.rect_position.y = row_y
#		get_node("UserInterface/HBoxContainer/Interface-Container/Locations").add_child(button) # Add the exit button the User Interface




func float_labels():
	
	var object_viewport_xy
	
	for cube in get_tree().get_nodes_in_group("Cube"):
		object_viewport_xy = camera.unproject_position(cube.translation)
		cube.get_child(0).anchor_left = object_viewport_xy.x / get_viewport().size.x
		cube.get_child(0).anchor_top = (object_viewport_xy.y + label_offset_y) / get_viewport().size.y
	
