extends Resource
##Un event est vide si son type est NONE
##Event.new() cree un Event vide
class_name Event

#Determine l'image d'illustration affichee. L'event GAME_OVER met fin au jeu et retour a ecran de depart 
enum Type {NONE,ATTACK,CHANTAGE,GAME_OVER}

@export var target_town : Array[Town.ID] = []
#Si true, ignore la variable TargetTown et affecte toutes les villes 
@export var target_all_town := true
@export var type : Type = Type.NONE
@export_multiline() var text : String = ""
@export var increase_min_guards : int = 0
@export var threat_increase : int = 0
@export var sell_price_modifier_increase : Dictionary[Merchandise.Type,float] = {}
