extends Node

#var resources : Dictionary = {1:["Poivre", load("res://assets/icons/placeholder.png")]}
#var events : Array = [[1]]

@onready var turn_manager: TurnManager = %TurnManager
@onready var expedition_manager: ExpeditionManager = %ExpeditionMgr
@onready var player: Player = %Player
@onready var town_manager: TownManager = %TownManager
@onready var ath: Ath = %Ath
@onready var trade_window: TradeWindow = %TradeWindow
@onready var event_win: EventWindow = %EventWindow
@onready var tuto_win: TutoWin = %TutoWin

func _ready() -> void:
	player.inventory_modified.connect(ath.set_ressource_amount)
	turn_manager.next_turned.connect(ath.set_turn)
	ath.next_turn.connect(go_to_next_turn)
	trade_window.launch_expedition.connect(_on_launch_expedition)
	event_win.game_over.connect(func()->void:
		get_tree().change_scene_to_file("res://baptiste/menu.tscn")
		)
	prepare_turn()
	if not OS.is_debug_build():
		tuto_win.appear()
		
	ath.help_btn_pressed.connect(func()->void:
		if not tuto_win.visible:
			tuto_win.appear())
	Volumes.music_changed.connect(music_volume)

func _on_player_updated(inv):
	%Ath.update_all(inv)

func go_to_next_turn()->void:
	turn_manager.next_turn()
	prepare_turn()
	
func prepare_turn()->void:
	turn_manager = %TurnManager
	expedition_manager = %ExpeditionMgr
	#Get the events affecting this turn and then apply them 
	var town_offers : Array[TownOffer] = turn_manager.get_turn_town_offers()
	var event : Event = turn_manager.get_turn_event()
	var current_turn := turn_manager.current_turn
	
	apply_event(event)
	#Get the results of the expeditions and 
	var expeditions_results : Dictionary[Merchandise.Type,float] = expedition_manager.update_expeditions(current_turn)
	
	#Update UI with the results of the expeditions and the events
	await hide_old_bubbles()
	pop_offer_bubbles(town_offers)
	process_expeditions_results(expeditions_results)

func apply_event(event : Event) ->void:
	if not event.text.is_empty():
		event_win.set_type(event.type)
		pop_event_win(event.text)
	
	trade_window.guard_cost+=event.guard_cost_increase
	var target_towns : Array[Town] = [] 
	if event.target_all_town:
		target_towns=town_manager.get_towns()
	else:
		for town_id in event.target_town:
			if not town_manager.town_exist(town_id):
				continue
			target_towns.append(town_manager.get_town(town_id))

	for town in target_towns:
		town.min_guards+=event.increase_min_guards
		town.threat_level+=event.threat_increase
		for merchandise_type in event.sell_price_modifier_increase.keys():
			if not town.sell_factor.has(merchandise_type):
				town.sell_factor[merchandise_type]=0.5
			town.sell_factor[merchandise_type]+=event.sell_price_modifier_increase[merchandise_type]
		if event.type == Event.Type.CONQUETE:
			town.icon_texture = town.FORTERESS_TEXTURE
		
func pop_event_win(text: String)->void:
	event_win.set_text(text)
	event_win.appear()

func pop_offer_bubbles(town_offers: Array[TownOffer])->void:
	for trade : TownOffer in town_offers:
		var town : Town = town_manager.get_town(trade.town)
		trade.threat_level =trade.threat_level + town.threat_level
		trade.min_gards = town.min_guards
		if trade.is_buying:
			trade.price_modifier = town.buy_factor[trade.merchadise] if town.buy_factor.has(trade.merchadise) else 1.0
		else:
			trade.price_modifier = town.sell_factor[trade.merchadise] if town.buy_factor.has(trade.merchadise) else 1.0
		
		town.current_offer=trade
		town.popup(trade.is_buying, trade.merchadise)

func hide_old_bubbles()->void:
	for town in town_manager.get_towns():
		await town.hide_popup()

func process_expeditions_results(expeditions_results : Dictionary[Merchandise.Type,float])->void:
	for merch_key in expeditions_results:
		player.modify_inventory(merch_key,expeditions_results[merch_key])

func _on_launch_expedition(expedition : Expedition)->void:
	expedition.start_turn=turn_manager.current_turn
	expedition.current_turn=turn_manager.current_turn
	var town : Town = town_manager.get_town(expedition.destination)
	if town != null:
		town.hide_popup()
	if expedition.success_duration==0:
		process_expeditions_results(expedition.delta_res)
		return
	expedition_manager.add_expedition(expedition)

func music_volume(value := -10.): $Music.volume_db = value
