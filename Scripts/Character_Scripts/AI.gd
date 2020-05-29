extends Node

var schedule = []

#npc_idle (a set of random things NPC will say when twiddling thumbs)
#npc_location_audio (a set of random things an NPC will say but only in that location)
#player_enters (a set of random things an NPC will say when the player enters (might ignore after the first time))
#movement audio (based on a given exit? I.e. I am going to the toilet, back in a minute)
#idle audio
#npc interaction (talk to each other)

var audio_npc_enters = []
var audio_npc_idle = []
var audio_npc_location = []



#Sequential paths can only have 2 locations, starting and ending
#use "Current" to represent an NPC's current position as a starting node for dynamic movement

#movement: sequential / random / static

func load_schedule():

	#work work work
	schedule.append({ 	"starttime":"00:00:00",
						"paths":["Living Area","Study","Balcony"],
						"speed": 10,
						"movement": "random",
						"looped_movement": true })

