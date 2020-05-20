extends Node

var schedule = []

#Sequential paths can only have 2 locations, starting and ending
#use "Current" to represent an NPC's current position as a starting node for dynamic movement

#movement: sequential / random / static

func load_schedule():
	#get up and showered - Graham is a cat
	schedule.append({ 	"starttime":"07:00:00",
						"paths":["Living Area"],
						"speed": 1,
						"movement": "static",
						"looped_movement": true })
	#path to work
	schedule.append({ 	"starttime":"08:00:00",
						"paths":["Living Area","R&D"],
						"speed":8,
						"movement": "sequential",
						"looped_movement": false })
	#working
	schedule.append({ 	"starttime":"08:04:00",
						"paths":["R&D","R&D Toilet"],
						"speed": 120,
						"movement": "random",
						"looped_movement": true })
	#path to quarters
	schedule.append({ 	"starttime":"17:31:00",
						"paths":["Current","R&D"],
						"speed": 8,
						"movement": "sequential",
						"looped_movement": true })
	#sleeping	
	schedule.append({ 	"starttime":"19:00:00",
						"paths":["Living Area"],
						"speed": 1,
						"movement": "static",
						"looped_movement": false })

