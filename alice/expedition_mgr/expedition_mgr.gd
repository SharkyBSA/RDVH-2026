extends Node
class_name ExpeditionManager

const MARITIME_TOKEN = preload("uid://bb7cgqp22fgvx")
const TERRESTRIAL_TOKEN = preload("uid://c45ii7ibuubkg")
const EXPEDITION_TOOLTIP = preload("uid://ca67r48c812aj")

@export var destination_paths : Dictionary[Town.ID,ExpeditionPath]={}

##Dictionnary storing an Expedition and its corresponding PathFollow (its visual represenation)
var _ongoing_expeditions : Dictionary[Expedition,ExpeditionToken] = {}
var _sinking_expeditions : Dictionary[Expedition,ExpeditionToken]= {}

func add_expedition(new_expedition: Expedition)->void:
	if not destination_paths.has(new_expedition.destination):
		print("WARNING: cant find destination",str(new_expedition.destination),"in destinations")
		return 
		
	var path : ExpeditionPath = destination_paths[new_expedition.destination]
	var expedition_token : ExpeditionToken
	if path.maritime_path:
		expedition_token = MARITIME_TOKEN.instantiate()
	else:
		expedition_token = TERRESTRIAL_TOKEN.instantiate()
	
	path.add_child(expedition_token)
	_ongoing_expeditions[new_expedition]= expedition_token
	expedition_token.is_hovered.connect(attach_expedition_tooltip)
	expedition_token.is_hovered.connect(func(_ignored)->void:
		path.appear()
		)
	expedition_token.is_not_hovered.connect(path.disappear)

func update_expeditions(turn : int)->Dictionary[Merchandise.Type,float]:
	var results:Dictionary[Merchandise.Type,float]= {}
	
	for expedition in _ongoing_expeditions:
		expedition.current_turn = turn
		if not expedition.is_over():
			continue
			
		if not expedition.will_succeed:
			continue
		
		for merchandise in expedition.delta_res:
			if not results.has(merchandise):
				results[merchandise] = 0
			results[merchandise] += expedition.delta_res[merchandise]
		
	progess_expeditions_tokens()
	return results

func progess_expeditions_tokens():
	var remaining_expeditions:  Dictionary[Expedition,ExpeditionToken] ={}

	#On fais disparaitre les token qui ont commenc  couler au tour precedent
	for expedition in _sinking_expeditions:
		_sinking_expeditions[expedition].kill()
		
	_sinking_expeditions = {}

	for expedition in _ongoing_expeditions:
		var expedition_token : ExpeditionToken = _ongoing_expeditions[expedition]
		var progress : float = expedition.get_advancement_ratio()
		if expedition.will_succeed == false :
			progress = min(0.9,progress)
		expedition_token.set_progess(progress)
					
		if expedition.is_over():
			if expedition.will_succeed:
				expedition_token.kill()
			else:
				expedition_token.start_sink()
				_sinking_expeditions[expedition]=expedition_token
		else:
			remaining_expeditions[expedition]=expedition_token
	_ongoing_expeditions=remaining_expeditions

func attach_expedition_tooltip(expedition_token : ExpeditionToken)->void:
	var corresponding_expedition := find_expedition(expedition_token)
	if corresponding_expedition == null:
		return
	
	var tooltip : ExpeditionTooltip = EXPEDITION_TOOLTIP.instantiate()
	expedition_token.add_child(tooltip)
	tooltip.position= Vector2(50,20)
	tooltip.turn_counter.text="Tours restants: "+str(max(0,corresponding_expedition.get_remaining_turns()))
	tooltip.threat.text="Risque d'échec: "+str(corresponding_expedition.fail_risk*100 as int)+"%"
	tooltip.cargaison.text="Gains au retour:"
	for merchandise_id in corresponding_expedition.delta_res:
		tooltip.cargaison.text+="\n - "+Merchandise.display_names[merchandise_id]+": "+str(corresponding_expedition.delta_res[merchandise_id] as int)
	
func find_expedition(expedition_token : ExpeditionToken)->Expedition:
	for expedition in _ongoing_expeditions:
		if _ongoing_expeditions[expedition] == expedition_token:
			return expedition
	for expedition in _sinking_expeditions:
		if _sinking_expeditions[expedition] == expedition_token:
			return expedition
	return null
	
