class_name ArrayTownOffer extends Resource

@export var offers : Array[TownOffer] = [] : get = get_town_offer_array

func get_town_offer_array() -> Array[TownOffer]:
	var array : Array[TownOffer] = []
	for i in offers.size():
		if offers[i] == null:
			array.append(TownOffer.new())
		else:
			array.append(offers[i])

	return array
