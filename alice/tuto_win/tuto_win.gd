extends Control
class_name TutoWin

@onready var expedition_path: ExpeditionPath = %ExpeditionPath
@onready var expedition_token: ExpeditionToken = %ExpeditionToken
@onready var expedition_path_2: ExpeditionPath = %ExpeditionPath2
@onready var expedition_token_terre: ExpeditionToken = %ExpeditionTokenTerre
@onready var start_btn: TextureButton = %Start

var paths : Array[ExpeditionPath] = []
var tokens : Array[ExpeditionToken] = []

var appeared_anchor_top: float
var appeared_anchor_bottom: float
var appear_tween: Tween

const APPEAR_DURATION := 0.7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	appeared_anchor_top=anchor_top
	appeared_anchor_bottom=anchor_bottom
	
	paths=[expedition_path,expedition_path_2]
	tokens=[expedition_token,expedition_token_terre]
	
	for path in paths:
		path.line.show()
	for token in tokens:
		token.set_progess(1.0)
	
	start_btn.pressed.connect(disappear)

func _process(_delta: float) -> void:
	for token in tokens:
		if token.move_tween != null && not token.move_tween.is_running():
			token.expedition_progress = 0.0
			token.set_progess(1.0)

func appear()->void:
	show()
	start_btn.disabled=false
	if appear_tween != null :
		appear_tween.kill()
	
	anchor_bottom=appeared_anchor_bottom+1
	anchor_top=appeared_anchor_top+1
	appear_tween = create_tween()
	appear_tween.set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	appear_tween.tween_property(self,"anchor_bottom",appeared_anchor_bottom,APPEAR_DURATION) 
	appear_tween.tween_property(self,"anchor_top",appeared_anchor_top,APPEAR_DURATION) 
	

func disappear()->void:
	show()
	start_btn.disabled=true

	if appear_tween != null :
		appear_tween.kill()
	
	anchor_bottom=appeared_anchor_bottom
	anchor_top=appeared_anchor_top
	
	appear_tween = create_tween()
	appear_tween.set_parallel().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	appear_tween.tween_property(self,"anchor_bottom",appeared_anchor_bottom+1,APPEAR_DURATION) 
	appear_tween.tween_property(self,"anchor_top",appeared_anchor_top+1,APPEAR_DURATION) 
	
	appear_tween.finished.connect(hide) 
