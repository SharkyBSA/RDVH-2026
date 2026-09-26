extends RefCounted
class_name Expedition

var destination : int = -1
var delta_res : Dictionary[Merchandise.Type, float]
var fail_risk : float
var start_turn : int
var current_turn : int
var end_turn : int

##Returns a float between 0 and 1 representing the advancement of expedition
##0: expedition started this turn 1 : the expedition is over 
func get_advancement_ratio()->float:
	return (1.0*current_turn-start_turn)/(1.0*end_turn-start_turn)

##helper function : return true if the expedition is over and must be resolved
func is_expedition_over()->bool:
	return get_advancement_ratio()>=1.0
