extends Control

@onready var player: Player = $Player
@onready var gold_amount: Label = $VBoxContainer/GoldAmount
@onready var pepper_amount: Label = $VBoxContainer/pepperAmount
@onready var gold_m_5: Button = $VBoxContainer2/HBoxContainer/GoldM5
@onready var golddelta: Label = $VBoxContainer2/HBoxContainer/golddelta
@onready var gold_p_5: Button = $VBoxContainer2/HBoxContainer/GoldP5
@onready var pepper_m_5: Button = $VBoxContainer2/HBoxContainer2/PepperM5
@onready var pepperdelta: Label = $VBoxContainer2/HBoxContainer2/pepperdelta
@onready var pepper_p_5: Button = $VBoxContainer2/HBoxContainer2/PepperP5
@onready var applydeltagold: Button = %applydeltagold
@onready var applydeltapepper: Button = %applydeltapepper
@onready var game_over: Label = $GameOver

var delta_gold : float = 0
var delta_pepper : float = 0

func _ready() -> void:
	player.game_over.connect(func()->void:
		game_over.text= "Oh no game over !")
	
	gold_m_5.pressed.connect(func()->void:
		delta_gold-=5
		update_ui()
		)
	gold_p_5.pressed.connect(func()->void:
		delta_gold+=5
		update_ui()
		)
	pepper_m_5.pressed.connect(func()->void:
		delta_pepper-=5
		update_ui()
		)
	pepper_p_5.pressed.connect(func()->void:
		delta_pepper+=5
		update_ui()
		)
		
	applydeltagold.pressed.connect(func()->void:
		apply_delta(0,delta_gold)
		update_ui())
		
	applydeltapepper.pressed.connect(func()->void:
		apply_delta(1,delta_pepper)
		update_ui())
	
	update_ui()

func apply_delta(key : int, delta: float)->void:
	player.modify_inventory(key,delta)

func update_ui()->void:
	gold_amount.text= "Gold: " + str(floori(player.get_gold_amount()))
	pepper_amount.text= "Pepper: " + str(floori(player.get_resource_amount(1)))
	golddelta.text= "Gold Delta: " + str(floori(delta_gold))
	pepperdelta.text= "Pepper delta: " + str(floori(delta_pepper))
	

	
