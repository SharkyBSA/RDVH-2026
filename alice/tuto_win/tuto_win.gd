extends Control
class_name TutoWin

@onready var expedition_path: ExpeditionPath = %ExpeditionPath
@onready var expedition_token: ExpeditionToken = %ExpeditionToken
@onready var expedition_path_2: ExpeditionPath = %ExpeditionPath2
@onready var expedition_token_terre: ExpeditionToken = %ExpeditionTokenTerre

var paths : Array[ExpeditionPath] = []
var tokens : Array[ExpeditionToken] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	paths=[expedition_path,expedition_path_2]
	tokens=[expedition_token,expedition_token_terre]
	
	for path in paths:
		path.line.show()
	for token in tokens:
		token.set_progess(1.0)

func _process(_delta: float) -> void:
	for token in tokens:
		if token.move_tween != null && not token.move_tween.is_running():
			token.expedition_progress = 0.0
			token.set_progess(1.0)

func appear()->void:
	show()

func disappear()->void:
	hide()
