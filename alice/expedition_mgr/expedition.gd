extends RefCounted
class_name Expedition

var destination : int = -1
var delta_res : Dictionary[Merchandise.Type, float]
var fail_risk : float
var will_succeed := true

var start_turn : int
var current_turn : int
var end_turn : int

##Returns a float between 0 and 1 representing the advancement of expedition
##0: expedition started this turn 1 : the expedition is over 
func get_advancement_ratio()->float:
	return (1.0*current_turn-start_turn)/(1.0*end_turn-start_turn)

##helper function : return true if the expedition is over and must be resolved
func is_over()->bool:
	return end_turn<=current_turn

func draw_fail()->void:
	will_succeed = randf_range(0.01,1.0)>fail_risk
