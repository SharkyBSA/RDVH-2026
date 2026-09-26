extends Node
class_name ExpeditionManager

const EXPEDITION_TOKEN = preload("uid://bb7cgqp22fgvx")
@export var destination_paths : Dictionary[int,Path2D]={}

##Dictionnary storing an Expedition and its corresponding PathFollow (its visual represenation)
var _ongoing_expeditions : Dictionary[Expedition,ExpeditionPathFollow2D] = {}

func add_expedition(new_expedition: Expedition)->void:
	if not destination_paths.has(new_expedition.destination):
		print("WARNING: cant find destination",str(new_expedition.destination),"in destinations")
		return 
		
	var path : Path2D = destination_paths[new_expedition.destination]
	var path_follow := ExpeditionPathFollow2D.new()
	var expedition_token : Node2D = EXPEDITION_TOKEN.instantiate()
	
	path_follow.add_child(expedition_token)
	path.add_child(path_follow)
	_ongoing_expeditions[new_expedition]= path_follow
	
func update_expeditions(turn : int)->Dictionary[Merchandise.Type,float]:
	var results:Dictionary[Merchandise.Type,float]= {}
	
	for expedition in _ongoing_expeditions:
		expedition.current_turn= turn
		if not expedition.is_over():
			continue
			
		if not expedition.will_succeed:
			continue
		
		for merchandise in expedition.delta_res:
			if not results.has(merchandise):
				results[merchandise]=0
			results[merchandise]+=expedition.delta_res[merchandise]
		
	progess_expeditions_tokens()
	return results

func progess_expeditions_tokens():
	var remaining_expeditions:  Dictionary[Expedition,ExpeditionPathFollow2D] ={}

	for expedition in _ongoing_expeditions:
		var path_follow : ExpeditionPathFollow2D = _ongoing_expeditions[expedition]
		var progress : float = expedition.get_advancement_ratio()
		path_follow.set_progess(progress)
		if expedition.is_over():
			path_follow.kill()
		else:
			remaining_expeditions[expedition]=_ongoing_expeditions[expedition]
	_ongoing_expeditions=remaining_expeditions
	
