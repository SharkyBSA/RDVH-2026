extends Control
class_name EventWindow

@onready var text_lbl: Label = %TextLbl
@onready var exit_btn: TextureButton = %ExitBtn
@onready var illustration: TextureRect = %Illustration

const GAME_OVER_SKULL = preload("uid://bypvxct1se7dr")
const PORTUGAIS = preload("uid://dqq7dpnqlgge4")
const BAGARRE = preload("uid://tth5im45vk82")

signal game_over

var event_type : Event.Type

func _ready() -> void:
	hide()
	exit_btn.pressed.connect(disappear)

func set_text(text : String)->void:
	text_lbl.text=text
	if event_type == Event.Type.GAME_OVER:
		var player : Player = %Player
		text_lbl.text=text+"\n Merci d'avoir joue ! Score: "+str(calcul_score())

func calcul_score()->int:
	var player : Player = %Player
	var score : int =0;
	for res in player.inventory:
		score+=player.inventory[res]*Merchandise.prices[res]
	return score


func set_type(type : Event.Type)->void:
	event_type = type
	match type:
		Event.Type.ATTACK:
			illustration.texture = BAGARRE
		Event.Type.CHANTAGE:
			illustration.texture = PORTUGAIS
		Event.Type.GAME_OVER:
			illustration.texture = GAME_OVER_SKULL

func appear()->void:
	show()
	
func disappear()->void:
	if event_type == Event.Type.GAME_OVER:
		game_over.emit()
	hide()
