extends Node
class_name TurnManager

@export var events : Array[Event] = []
@export var town_offers : Array[TownOffer] = []

var current_turn : int = 0
signal next_turned

func next_turn() -> void:
	current_turn+=1
	next_turned.emit()

func get_turn_event()->Event:
	if current_turn<0 or current_turn>=events.size():
		return Event.new()
	var turn_event : Event = events[current_turn]
	if turn_event == null:
		turn_event = Event.new()
	
	return turn_event

func get_turn_town_offers()->TownOffer:
	if current_turn<0 or current_turn>=town_offers.size():
		return TownOffer.new()
	var turn_offer: TownOffer = town_offers[current_turn]
	if turn_offer == null:
		turn_offer = TownOffer.new()
	
	return turn_offer
