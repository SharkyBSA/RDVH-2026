extends Resource
##Un event est vide si son type est NONE
##Event.new() cree un Event vide
class_name Event

enum Type {NONE,ATTACK,CHANTAGE,GAME_OVER}

@export var target_town : Town.ID = Town.ID.GOA
@export var type : Type = Type.NONE
@export_multiline() var text : String = ""
@export var increase_min_guards : int = 0
@export var threat_increase : int = 0
