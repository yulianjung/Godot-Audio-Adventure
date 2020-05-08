extends CanvasLayer

onready var earth_time = $"HBoxContainer/MainScreen-Container/LocationImage/ImageOverlay/TopOverlay/EarthTime"
#signal ui_faded

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if earth_time.text != G.earth_time:
		earth_time.text = "Earth Time: " + G.earth_time




#func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
#	emit_signal("ui_faded")
