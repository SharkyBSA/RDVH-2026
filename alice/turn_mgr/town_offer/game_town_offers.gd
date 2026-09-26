extends Resource
class_name GameTownOffers

@export var town_offers: Array[ArrayTownOffer] 

func get_town_offers_of_turn(turn: int)->Array[TownOffer]:
	if turn<0 or turn>=town_offers.size() or town_offers[turn] == null:
		return []
	return town_offers[turn].get_town_offer_array()
	
