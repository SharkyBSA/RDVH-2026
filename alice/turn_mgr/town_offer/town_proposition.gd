extends Resource
##Une offre d'un ville pour une expedition. Une offre est vide si sa variable town est -1
##TownOffer.new() cree une offre vide
class_name TownOffer

@export var town : int = -1
@export var resource : String = ""
## Negative means that it buys
@export var amount : int = 0

#func convert_offer(offer_send_amount: int)->int:
	#return offer_send_amount*receive_amount/send_amount
