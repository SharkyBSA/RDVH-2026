extends Node
class_name ExpeditionManager

@export var destination_paths : Dictionary[int,Path2D]={}

var _ongoing_expeditions : Array[Expedition] = []

func add_expedition(new_expedition: Expedition)->void:
	_ongoing_expeditions.append(new_expedition)

func resolve_expeditions(turn : int)->Dictionary[Merchandise.Type,float]:
	var results:Dictionary[Merchandise.Type,float]= {}
	
	var remaining_expeditions: Array[Expedition] = []
	for expedition in _ongoing_expeditions:
		expedition.current_turn= turn
		if not expedition.is_over():
			remaining_expeditions.append(expedition)
			continue
			
		if not expedition.will_succeed:
			continue
		
		for merchandise in expedition.delta_res:
			if not results.has(merchandise):
				results[merchandise]=0
			results[merchandise]+=expedition.delta_res[merchandise]
	_ongoing_expeditions = remaining_expeditions
	return results
