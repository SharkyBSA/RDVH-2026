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
	event_lbl.text = "Event: "+turn_manager.get_turn_event()
	proposition.text = "Proposition: "+turn_manager.get_turn_town_offers()
