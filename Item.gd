extends Area


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass



func _on_Area_mouse_entered() -> void:
	$MeshInstance.translation.y += 0.1


func _on_Area_mouse_exited() -> void:
	$MeshInstance.translation.y -= 0.1
