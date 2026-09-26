extends Node

var resources : Dictionary = {1:["Poivre", load("res://assets/icons/placeholder.png")]}
var events : Array = [[1]]

func _on_turn_manager_next_turned(turn):
	for trade : Town in $%TownManager.get_children():
		trade.hide_popup()
	for trade : TownOffer in $TurnManager.get_turn_town_offers():
		var town : Town = $%TownManager.get_child(trade.town)
		town.res_amount = trade.send_amount
		town.res_type = trade.res_to_send
		town.added_threat = trade.threat_level + town.threat_level
		town.popup()
	$UI/Ath.set_turn(turn)

func _on_player_updated(inv):
	$UI/Ath.update_all(inv)
