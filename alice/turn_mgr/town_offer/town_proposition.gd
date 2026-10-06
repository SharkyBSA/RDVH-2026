extends Resource
##Une offre d'un ville pour une expedition. Une offre est vide si sa variable town est -1
##TownOffer.new() cree une offre vide
class_name TownOffer

@export var town : Town.ID = Town.ID.GOA
@export var is_buying : bool = false
@export var merchadise : int = Merchandise.Type.SPICE
@export var threat_level := 0
@export var amount : float = 0
var min_gards: int =0
var price_modifier : float = 1.0
