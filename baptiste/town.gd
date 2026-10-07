extends Control
class_name Town

enum ID {
	DELHI=0,
	CALICUT=1,
	GOA=2,
	CHAUL=3,
	COLOMBO=4,
	PATNA=5,
	ADEN=6,
	ORMUZ=7,
	DEBAL=8,
	SOFALA=9,
	ZANZIBAR=10,
	MALACCA=11,
	TIMOR=12,
	CHATIGAON=13,
	SYRIAM=14
}

const FORTERESS_TEXTURE : Texture2D = preload("res://assets/Trading_interface/Fortugais_icone.png")

@onready var _icon: TextureRect = %Icon

@export var icon_texture : Texture2D : 
	set(new_icon):
		icon_texture=new_icon
		if is_node_ready():
			_icon.texture=icon_texture
		
@export var town_name := ""
@export var index :ID= 0
@export var transport_mode := 0
@export var transport_turn := 1
@export var transport_threat := 0
@export var threat_level := 0
#Facteur applique au prix 
@export var buy_factor : Dictionary[Merchandise.Type,float]= {
	Merchandise.Type.SILK:1.5,
	Merchandise.Type.IVORY:1.5,
	Merchandise.Type.COTON:1.5,
	Merchandise.Type.SPICE:1.5,
	Merchandise.Type.ANIMALS:1.5,
	Merchandise.Type.SLAVES:1.5,
	Merchandise.Type.PEPPER:1.5	
}
@export var sell_factor : Dictionary[Merchandise.Type,float]= {
	Merchandise.Type.SILK:0.5,
	Merchandise.Type.IVORY:0.5,
	Merchandise.Type.COTON:0.5,
	Merchandise.Type.SPICE:0.5,
	Merchandise.Type.ANIMALS:0.5,
	Merchandise.Type.SLAVES:0.5,
	Merchandise.Type.PEPPER:0.5	
}
@export var sfx : Array[AudioStreamMP3] = []
@export var start_town := false
@export var color : Color = Color(0.7, 0, 0)
@export var reverse_popup := false
@export var flip_icon_horizontal := false

var current_offer : TownOffer
var min_guards : int = 0
var _bubble_displayed:= false

signal clicked(display_name, town_offer, transport_turn)

func _ready():
	$VBoxContainer/TownName.text = town_name
	$VBoxContainer/TownName.modulate = color
	%Icon.texture = icon_texture
	%Icon.flip_h = flip_icon_horizontal

func _on_texture_button_pressed():
	if $TradeHBox.modulate.a == 1:
		emit_signal("clicked", self, current_offer, transport_turn)
		$AudioStreamPlayer.stream = sfx[randi_range(0, sfx.size()-1)]
		%Music.volume_db = -15
		$AudioStreamPlayer.play()
		await $AudioStreamPlayer.finished
		%Music.volume_db = -5

## Show the popup to start a trade. If type is 0, hides the down. 1, hides the up. 2, show both.
func popup(type := 0, res := 0):
	$TradeHBox/ArrowUp.visible = true if type == 0 else false
	$TradeHBox/ArrowDown.visible = true if type == 1 else false
	# Animation
	$TradeHBox.position.y = 0
	$TradeHBox.modulate.a = 1
	var tween = create_tween()
	var new_pos = -80 if !reverse_popup else 60
	tween.tween_property($TradeHBox, "position:y", new_pos, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	_bubble_displayed=true
	match res:
		Merchandise.Type.PEPPER:	$TradeHBox/TextureButton/TextureRect.texture = load("res://assets/poivre.png")
		Merchandise.Type.SILK:	$TradeHBox/TextureButton/TextureRect.texture = load("res://assets/icons/ettoffe.png")
		Merchandise.Type.IVORY:	$TradeHBox/TextureButton/TextureRect.texture = load("res://assets/ivoire.png")
		Merchandise.Type.COTON:	$TradeHBox/TextureButton/TextureRect.texture = load("res://assets/icons/Coton.png")
		Merchandise.Type.GEMS:	$TradeHBox/TextureButton/TextureRect.texture = load("res://assets/icons/pierres.png")
		Merchandise.Type.SPICE:	$TradeHBox/TextureButton/TextureRect.texture = load("res://assets/icons/epices.png")
		Merchandise.Type.ANIMALS:	$TradeHBox/TextureButton/TextureRect.texture = load("res://assets/icons/chevaux.png")
		Merchandise.Type.SLAVES:	$TradeHBox/TextureButton/TextureRect.texture = load("res://assets/icons/esclave.png")

func hide_popup():
	if not _bubble_displayed:
		return
	var tween = create_tween()
	tween.tween_property($TradeHBox, "modulate:a", 0, 0.1)
	_bubble_displayed=false
	await tween.finished
