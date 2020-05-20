extends Node

var schedule = []

#Sequential paths can only have 2 locations, starting and ending
#use "Current" to represent an NPC's current position as a starting node for dynamic movement

#movement: sequential / random / static

func load_schedule():

	#work work work
	schedule.append({ 	"starttime":"00:00:00",
						"paths":["R&D","R&D Toilet","Elevator R&D"],
						"speed": 8,
						"movement": "random",
						"looped_movement": true })

