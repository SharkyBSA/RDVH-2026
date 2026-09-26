extends Resource
##Un event est vide si son type est NONE
##Event.new() cree un Event vide
class_name Event

enum Type {NONE,TEMPEST,FOE,SPAWN}

@export var target_town : int = 0
@export var type : Type = Type.NONE
@export var turn := 0
