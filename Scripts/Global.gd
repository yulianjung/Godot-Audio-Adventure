extends Node

var play_narrative = false
var player_name = "Jove"
var talked_to_ai = false


var is_playing_cutscene = false
var timer = 0

var earth_time = ""
var e_seconds = 0
var e_minutes = 0
var e_hours = 7

#var jupiter_month
#var jupiter_year
#var jupiter_year
#var jupiter_time = 0.00
#var jupiter_minute = 24.79
var jupiter_day_minutes = 5100

const TIME_PERIOD = 1 # 1000ms

func player():
	return MSG.level_root().get_node("main/Player")

#
#func show_fireworks():
#	MSG.level_root().get_node("fireworks").emitting = true
#	yield(MSG.time(2), "timeout")
#	MSG.level_root().get_node("fireworks").emitting = false


func _process(delta: float) -> void:
	timer += delta
	if timer > TIME_PERIOD:
		e_seconds += 1
		if e_seconds > 59:
			e_minutes += 1
			e_seconds = 0
		if e_minutes > 59:
			e_hours += 1
			e_minutes = 0
		if e_hours > 23:
			e_hours = 0
		#emit_signal("second")
		
		var print_h = str(e_hours)
		if print_h.length() < 2:
			print_h = "0" + str(e_hours)
		var print_m = str(e_minutes)
		if print_m.length() < 2:
			print_m = "0" + str(e_minutes)
		var print_s = str(e_seconds)
		if print_s.length() < 2:
			print_s = "0" + str(e_seconds)		
		
		earth_time = "Earth Time: " + print_h + ":" + print_m + ":" + print_s
		# Reset timer
		timer = 0



func update_gui():
	get_tree().get_current_scene().update_gui()


#Extracts the node name from an absolute node path
func extract_node( nodepath: NodePath ):
	#print ("Outputted " + nodepath.get_name( nodepath.get_name_count()-1 ))
	return nodepath.get_name( nodepath.get_name_count()-1 )
	
