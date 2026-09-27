extends Resource
##Une offre d'un ville pour une expedition. Une offre est vide si sa variable town est -1
##TownOffer.new() cree une offre vide
class_name TownOffer

@export var town : int = -1
@export var is_buying : bool = false
@export var merchadise := -1
@export var threat_level := 0
@export var amount : float = 0
