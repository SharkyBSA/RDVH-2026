extends Control
class_name Ath

@onready var gold: Label = %Gold
@onready var pepper: Label = %Pepper
@onready var silk: Label = %Silk
@onready var ivory: Label = %Ivory
@onready var coton: Label = %Coton
@onready var gems: Label = %Gems
@onready var spice: Label = %Spice
@onready var animals: Label = %Animals
@onready var porcelain: Label = %Porcelain

@onready var next_turn_btn: TextureButton = %NextTurnBtn
@onready var year_lbl: Label = %YearLbl
@onready var turn_lbl: Label = %TurnLbl
@onready var pausebtn: TextureButton = %Pausebtn

@onready var resource_labels : Dictionary[int, Label]={
	0:gold,
	1:pepper,
	2:silk,
	3:ivory,
	4:coton,
	5:gems,
	6:spice,
	7:animals,
	8:porcelain}

signal next_turn
signal pause_btn_pressed

func _ready() -> void:
	next_turn_btn.pressed.connect(next_turn.emit)
	pausebtn.pressed.connect(pause_btn_pressed.emit)

func set_ressource_amount(res_key :int , amount: float)->void:
	if not resource_labels.has(res_key):
		return
	resource_labels[res_key].text=str(floori(amount))

func set_turn(turn :int)->void:
	turn_lbl.text = "Tour: "+str(turn)
	year_lbl.text = "Annee: "+str(1490+floori(turn/4.0))



		
		
		
