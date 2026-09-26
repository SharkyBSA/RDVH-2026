extends Resource
class_name Event

enum Type {NONE,TEMPEST,FOE}

@export var target_town : int = -1
@export var type : Type = Type.NONE
