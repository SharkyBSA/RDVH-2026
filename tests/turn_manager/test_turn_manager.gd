extends Control

@onready var turn_manager: TurnManager = %TurnManager
@onready var event_lbl: Label = %Event
@onready var next_turn_btn: Button = %NextTurn
@onready var proposition: Label = %Proposition

func _ready() -> void:
	next_turn_btn.pressed.connect(go_next_turn)
	update_ui()
	
func go_next_turn()->void:
	turn_manager.next_turn()
	update_ui()
	
func update_ui():
	var event: Event = turn_manager.get_turn_event()
	var event_string : String = "No event"
	
	var town_offer: TownOffer = turn_manager.get_turn_town_offers()
	var town_offer_string : String = "No offer"
	
	match event.type:
		Event.Type.TEMPEST:
			event_string = "Tempete !"
		Event.Type.FOE:
			event_string = "Invasion"
			
	
	if town_offer.town != -1:
		town_offer_string = "Ville "+str(town_offer.town)
		town_offer_string += " offers "+str(town_offer.receive_amount) + " "+ town_offer.res_to_receive
		town_offer_string += " and you send "+str(town_offer.send_amount) + " "+ town_offer.res_to_send
	
	event_lbl.text = "Event: "+event_string
	proposition.text = "Proposition: "+town_offer_string
