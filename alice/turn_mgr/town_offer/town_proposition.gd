extends Resource
##Une offre d'un ville pour une expedition. Une offre est vide si sa variable town est -1
##TownOffer.new() cree une offre vide
class_name TownOffer

@export var town : int = -1
@export var res_to_send : String = ""
@export var send_amount : float = 0
@export var res_to_receive : String = ""
@export var receive_amount : float = 0

func convert_offer(offer_send_amount: float)->float:
	return offer_send_amount*receive_amount/send_amount
