extends RefCounted
class_name Expedition

var destination : Town.ID = Town.ID.CALICUT
var delta_res : Dictionary[Merchandise.Type, float]
var fail_risk : float

var will_succeed := true
var start_turn : int
var success_duration :int
var current_turn : int
var _real_duration : int

##Returns a float between 0 and 1 representing the advancement of expedition
##0: expedition started this turn 1 : the expedition is over 
func get_advancement_ratio()->float:
	return (1.0*current_turn-start_turn)/(1.0*success_duration)

##return true if the expedition is over and must be resolved
func is_over()->bool:
	return (start_turn+_real_duration)<=current_turn

##A appeler une fois. Dtermine a l'avance le resulat de l'expedition. Si elle
##doit echouer, determiner a quel moment de l'expedition elle echouera 
func draw_fail()->void:
	will_succeed = randf_range(0.01,1.0)>fail_risk
	if not will_succeed:
		_real_duration=randi_range(1,max(success_duration-1,1))
	else:
		_real_duration=success_duration
