extends Control

@onready var ath: Ath = %Ath
@onready var next_turn: Label = %next_turn
@onready var pause: Label = $pause
@onready var button: Button = %Button
@onready var button_2: Button = %Button2
@onready var button_3: Button = %Button3
@onready var button_4: Button = %Button4
@onready var button_5: Button = %Button5
@onready var button_6: Button = %Button6
@onready var button_7: Button = %Button7
@onready var button_8: Button = %Button8
@onready var button_9: Button = %Button9


var next_turn_counter : int =0
var paused : bool = false
var inventory : Array[int] = [0,0,0,0,0,0,0,0,0,0]

func _ready() -> void:
	ath.next_turn.connect(func()->void:
		next_turn_counter+=1
		next_turn.text="Next_turn_pressed: "+str(next_turn_counter)
		ath.set_turn(next_turn_counter))
		
	ath.pause_btn_pressed.connect(func()->void:
		paused= not paused
		pause.text="Paused: "+str(paused))
	
	button.pressed.connect(increment_res.bind(0))
	button_2.pressed.connect(increment_res.bind(1))
	button_3.pressed.connect(increment_res.bind(2))
	button_4.pressed.connect(increment_res.bind(3))
	button_5.pressed.connect(increment_res.bind(4))
	button_6.pressed.connect(increment_res.bind(5))
	button_7.pressed.connect(increment_res.bind(6))
	button_8.pressed.connect(increment_res.bind(7))
	button_9.pressed.connect(increment_res.bind(8))

func increment_res(res_key : int)->void:
	inventory[res_key]+=5
	ath.set_ressource_amount(res_key,inventory[res_key])
	
	
