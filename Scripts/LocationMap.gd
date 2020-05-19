extends Node

class_name LocationMap

var map: Dictionary

# build the map of possible routes from any location to any other location.
# may take some time but only need to be done once at the beginning of the game.
func build_map(locations: Array) -> void:
#	create a new map and store direct exit locations

	map = Dictionary()
	for location in locations:
		var routes: Dictionary = Dictionary()
		map[location.name] = routes
		for exit in location.exits:
			var route: Array = Array()
			route.append(exit)
			var exit_location = exit.get_location()
			routes[exit_location.name] = route
	
#	repeatedly try to locate new routes by checking adjacent location exits
#	until no more new routes are discovered

	var found: bool = true		# initially set true to run at least one time
	while found:				# keeps repeating until no new routes are discovered
		found = false			# set default to false until a route is discovered

	#	try to find routes between every location
		for location1 in locations:				# take one location
			for location2 in locations:			# take another location
			#	skip if its the same location
				if location1 != location2:
				#	retrieve all the current routes for the first location
					var routes: Dictionary = map[location1.name]
				#	skip if there is already a route to the second location
					if not routes.has(location2.name):
					#	variable to assign the "cheapest" route
						var selected_route = null
					#	check adjacent locations from exits in the first location
						for exit_location in routes.keys():
						#	retrieve routes from adjacent location
							var sub_routes: Dictionary = map[exit_location]
						#	check if there is already a route to second location
							if sub_routes.has(location2.name):
							#	if found, merge routes from adjacent and second location
								var route1 = routes[exit_location].duplicate()
								var route2 = sub_routes[location2.name]
								for node in route2: route1.append(node)
							#	if a previous route was found, assign only the
							#	cheapest one based on size of the route	
								if (selected_route == null or
									selected_route.size() > route1.size()):
									selected_route = route1
									
					#	if a new route has been found, add it to the routes of
					#	the first location and make sure the loop repeats
					#	one more time to check for further routes
						if selected_route != null:
							routes[location2.name] = selected_route
							found = true	# to repeat checking for more routes

# retrieve a single route by location names
func get_route_by_name(location1: String, location2: String) -> Array:
	if map.has(location1):
		var routes = map[location1]
		if routes.has(location2): return routes[location2]
	return Array()	# empty array if no route

# retrieve a single route by location nodes
func get_route(location1: Location, location2: Location) -> Array:
	return get_route_by_name(location1.name, location2.name)

# display all the routes in the map
func print_map() -> void:							
	for location in map.keys():
		print("\nLocation:", location)
		var routes = map[location]
		for route_name in routes.keys():
			print("-> ", route_name,":")
			var route = routes[route_name]
			for exit in route: print("\t- ", exit.name)

#	query the route from the location map and display the results
func print_route_from(location1: String, location2: String)	-> void:
	var route = get_route_by_name(location1, location2)
	if not route: print("There is no route from ", location1, " to ", location2, ".")
	else:
		print("\nTo go to ",location2, " from ", location1, ":")
		for exit in route:	
			print("- ", exit.name)

