extends Node
class_name TurnManager

@export var events : GameEvents 
@export var town_offers : GameTownOffers

var current_turn : int = 0
signal next_turned

func next_turn() -> void:
	current_turn+=1
	next_turned.emit()

##Permet de recuper l'event de ce tour
func get_turn_event()->Event:
	return events.get_event_of_turn(current_turn)

##Permet de recuperer toutes les offres de villes pour ce tour 
func get_turn_town_offers()->Array[TownOffer]:
	return town_offers.get_town_offers_of_turn(current_turn)
	
