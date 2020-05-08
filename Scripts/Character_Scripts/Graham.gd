extends Node

var schedule = []

func load_schedule():
	#get up and showered
	schedule.append({ 	"starttime":"07:00:00",
						"paths":["Living Area","Study","Living Area","Balcony"],
						"speed": 60,
						"movement": "sequential",
						"looped_movement": true })
	#path to work
	schedule.append({ 	"starttime":"08:01:00",
						"paths":["Living Area","Study","Living Area","Balcony"],
						"speed":8,
						"movement": "sequential",
						"looped_movement": false })
	#working
	schedule.append({ 	"starttime":"08:04:00",
						"paths":["Living Area","Study","Living Area","Balcony"],
						"speed": 120,
						"movement": "random",
						"looped_movement": true })
	#path to quarters
	schedule.append({ 	"starttime":"17:31:00",
						"paths":["Living Area","Study","Living Area","Balcony"],
						"speed": 8,
						"movement": "random",
						"looped_movement": true })
	#sleeping	
	schedule.append({ 	"starttime":"19:00:00",
						"paths":["Living Area"],
						"speed": 100,
						"movement": "sequential",
						"looped_movement": false })

