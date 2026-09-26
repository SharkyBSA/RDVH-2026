extends Resource
class_name GameEvents

@export var events: Array[Event] = [] : get = get_game_events

func get_event_of_turn(turn: int)->Event:
	if turn<0 or turn>=events.size():
		return Event.new()
	return get_game_events()[turn]
	
func get_game_events() -> Array[Event]:
	var array : Array[Event] = []
	for i in events.size():
		if events[i] == null:
			array.append(Event.new())
		else:
			array.append(events[i])

	return array
