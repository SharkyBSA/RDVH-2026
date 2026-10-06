extends Control
class_name TownManager

var _towns : Dictionary[Town.ID,Town] = {}

func _ready() -> void:
	for child in get_children():
		if child is Town:
			_towns[child.index]=child

func get_towns()->Array[Town]:
	return _towns.values()

func get_town(index : Town.ID) -> Town:
	if town_exist(index):
		return _towns[index]
	return null

func town_exist(index : Town.ID)->bool:
	return _towns.has(index)
