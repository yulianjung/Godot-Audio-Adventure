extends Node

var schedule = []


#npc_idle (a set of random things NPC will say when twiddling thumbs)
#npc_location_audio (a set of random things an NPC will say but only in that location)
#player_enters (a set of random things an NPC will say when the player enters (might ignore after the first time))
#movement audio (based on a given exit? I.e. I am going to the toilet, back in a minute)
#idle audio
#npc interaction (talk to each other)

var audio_npc_enters = ["player_enter_1.ogg", "player_enter_2.ogg"]
var audio_npc_idle = []
var audio_npc_location = [	{ "Living Area": ["meow", "scratch", "tinypump"] }, 
							{ "R&D": ["typing"] }
						 ]



#Sequential paths can only have 2 locations, starting and ending
#use "Current" to represent an NPC's current position as a starting node for dynamic movement

#movement: sequential / random / static
func load_schedule():
	#get up and showered - Graham is a cat
	schedule.append({ 	"starttime":"07:00:00",
						"paths":["Living Area","Study","Balcony"],
						"speed": 6,
						"movement": "random",
						"looped_movement": true })
	#path to work
	schedule.append({ 	"starttime":"08:00:00",
						"paths":["Current","R&D"],
						"speed":6,
						"movement": "sequential",
						"looped_movement": false })
	#working
	schedule.append({ 	"starttime":"08:01:00",
						"paths":["R&D","R&D Toilet"],
						"speed": 120,
						"movement": "random",
						"looped_movement": true })
	#path to quarters
	schedule.append({ 	"starttime":"17:31:00",
						"paths":["Current","Living Area"],
						"speed": 8,
						"movement": "sequential",
						"looped_movement": true })
	#sleeping	
	schedule.append({ 	"starttime":"19:00:00",
						"paths":["Living Area"],
						"speed": 1,
						"movement": "static",
						"looped_movement": false })




