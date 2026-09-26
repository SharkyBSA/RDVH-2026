extends Node
class_name TurnManager

var current_turn : int = 0
@export var events : Array[String] =["","Tempete","","","Portugais"]
@export var town_offers : Array[String] = ["Ville A offre 50 poivre pour 10 or","Ville b offre 20 or pour 3 poivre"]

signal next_turned

func next_turn() -> void:
	current_turn+=1
	next_turned.emit()

func get_turn_event()->String:
	if current_turn<0 or current_turn>=events.size():
		return ""
	return events[current_turn]

func get_turn_town_offers()->String:
	if current_turn<0 or current_turn>=town_offers.size():
		return ""
	return town_offers[current_turn]
