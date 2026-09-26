extends Resource
##Un event est vide si son type est NONE
##Event.new() cree un Event vide
class_name Event

enum Type {NONE,TEMPEST,FOE}

@export var target_town : int = -1
@export var type : Type = Type.NONE
