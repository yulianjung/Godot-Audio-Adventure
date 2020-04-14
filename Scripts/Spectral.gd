extends Node2D


const VU_COUNT = 28
const FREQ_MAX = 3500

const MIN_DB = 60
const SMOOTH = 0.01

const BASE_OPACITY = 50

var spectrum


func _draw():
	#warning-ignore:integer_division
	var prev_hz = 0
	var current_bar
	for i in range(1, VU_COUNT+1):	
		current_bar = get_tree().get_current_scene().get_node("UserInterface/HBoxContainer/MainScreen-Container/LocationImage/ImageOverlay/BottomMidOverlay/HBoxContainer/Bar"+str(i))
		var hz = i * FREQ_MAX / VU_COUNT;
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1)

		#set opacity of bar based on current energy and base_opacity with a max value of 255
		current_bar.modulate.a = (BASE_OPACITY + (130 * energy)) / 255

		#get current value of the current bar and reduce it by SMOOTH
		current_bar.value = current_bar.value - SMOOTH
		
		#only update the current bar if greater than current value
		if energy > current_bar.value:
			#update current bars vertical height
			current_bar.value = energy
		prev_hz = hz
		
	#$center/hbox/v1.value = (AudioServer.get_bus_peak_volume_left_db(bus,0) + AudioServer.get_bus_peak_volume_right_db(bus,0)) / 2 		
	#get_tree().get_current_scene().get_node("UserInterface/HBoxContainer/MainScreen-Container")
		


func _process(_delta):
	update()


func _ready():
	spectrum = AudioServer.get_bus_effect_instance(0,0)
