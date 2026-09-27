extends Node

var resources : Dictionary = {1:["Poivre", load("res://assets/icons/placeholder.png")]}
var events : Array = [[1]]

@onready var turn_manager: TurnManager = %TurnManager
@onready var expedition_manager: ExpeditionManager = %ExpeditionManager
@onready var player: Player = %Player
@onready var town_manager: Node = %TownManager
@onready var ath: Ath = %Ath
@onready var trade_window: TradeWindow = %TradeWindow

func _ready() -> void:
	player.inventory_modified.connect(ath.set_ressource_amount)
	turn_manager.next_turned.connect(ath.set_turn)
	ath.next_turn.connect(go_to_next_turn)
	trade_window.launch_expedition.connect(_on_launch_expedition)
	
	##Temporaire pour le test
	#var expedition1:=Expedition.new()
	#var expedition2:=Expedition.new()
	#
	#expedition1.end_turn=4
	#expedition2.end_turn=6
	#expedition1.start_turn=0
	#expedition2.start_turn=0
	#expedition1.current_turn=0
	#expedition2.current_turn=0
	#expedition1.fail_risk=0
	#expedition2.fail_risk=0
	#expedition1.destination=0
	#expedition2.destination=1
	#expedition1.delta_res={0:5,2:3,1:1}
	#expedition2.delta_res={1:9,3:2.3}
	#
	#expedition1.draw_fail()
	#expedition2.draw_fail()
	#
	#expedition_manager.add_expedition(expedition2)
	#expedition_manager.add_expedition(expedition1)
	##Fin temporaire
	prepare_turn()

func go_to_next_turn()->void:
	turn_manager.next_turn()
	prepare_turn()
	
func prepare_turn()->void:
	#Get thes events affecting this turn and then apply them (TODO) 
	var town_offers : Array[TownOffer] = turn_manager.get_turn_town_offers()
	var _event : Event = turn_manager.get_turn_event()
	var current_turn := turn_manager.current_turn
	
	#Get the results of the expeditions and 
	var expeditions_results : Dictionary[Merchandise.Type,float] = expedition_manager.update_expeditions(current_turn)
	
	#Update UI with the results of the expeditions and the events
	await hide_old_bubbles()
	pop_offer_bubbles(town_offers)
	process_expeditions_results(expeditions_results)

func pop_offer_bubbles(town_offers: Array[TownOffer])->void:
	for trade : TownOffer in town_offers:
		var town : Town = town_manager.get_child(trade.town)
		town.res_amount = floori(trade.send_amount)
		town.res_type = trade.res_to_send
		town.added_threat = trade.threat_level + town.threat_level
		town.popup()

func hide_old_bubbles()->void:
	for town in town_manager.get_children():
		await town.hide_popup()

func process_expeditions_results(expeditions_results : Dictionary[Merchandise.Type,float])->void:
	for merch_key in expeditions_results:
		player.modify_inventory(merch_key,expeditions_results[merch_key])

func _on_launch_expedition(expedition : Expedition)->void:
	expedition.start_turn=turn_manager.current_turn
	expedition.current_turn=turn_manager.current_turn
	var town : Town = town_manager.get_child(expedition.destination)
	if town != null:
		town.hide_popup()
	expedition_manager.add_expedition(expedition)
