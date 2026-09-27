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
@onready var slaves: Label = %Slaves

@onready var next_turn_btn: TextureButton = %NextTurnBtn
@onready var year_lbl: Label = %YearLbl
@onready var turn_lbl: Label = %TurnLbl
@onready var pausebtn: TextureButton = %Pausebtn

@onready var resource_labels : Dictionary[int, Label]={

	Merchandise.Type.GOLD:gold,
	Merchandise.Type.PEPPER:pepper,
	Merchandise.Type.SILK:silk,
	Merchandise.Type.IVORY:ivory,
	Merchandise.Type.COTON:coton,
	Merchandise.Type.SPICE:spice,
	Merchandise.Type.ANIMALS:animals,
	Merchandise.Type.SLAVES:slaves}


signal next_turn
signal pause_btn_pressed

func _ready() -> void:
	pausebtn.pressed.connect(pause_btn_pressed.emit)
	pass_button_animation()

func update_all(inventory : Dictionary):
	for i in range(0, 8): set_ressource_amount(i, inventory.get(i))

func set_ressource_amount(res_key :Merchandise.Type, amount: float)->void:
	if not resource_labels.has(res_key):
		return
	resource_labels[res_key].text=str(floori(amount))

func set_turn(turn : int)->void:
	turn_lbl.text = "Tour : "+str(turn)
	year_lbl.text = "Année : "+str(1501+floori(turn/4.0))

func _on_next_turn_btn_pressed():
	emit_signal("next_turn")


func _on_pausebtn_pressed():
	get_tree().change_scene_to_file("res://baptiste/menu.tscn")

func pass_button_animation():
	var tween = create_tween()
	tween.tween_property(%NextTurnBtn, "modulate", Color(1, 1, 0.8), 1)
	await tween.finished
	var tween2 = create_tween()
	tween2.tween_property(%NextTurnBtn, "modulate", Color(1, 1, 1), 1)
	await tween2.finished
	pass_button_animation()
