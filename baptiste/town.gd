extends Control
class_name Town

@export var town_name := ""
@export var transport_mode := 0
@export var transport_turn := 1
@export var transport_threat := 0
@export var threat_level := 0
@export var index := 0
@export var sfx : Array[AudioStreamMP3] = []
@export var start_town := false
@export var color : Color = Color(0.7, 0, 0)
@export var reverse_popup := false
var current_offer : TownOffer
var res_type := 0
var res_amount := 0
var added_threat := 0

var _bubble_displayed:= false

signal clicked(display_name, town_offer, transport_turn)

func _ready():
	$VBoxContainer/TownName.text = town_name
	$VBoxContainer/TownName.modulate = color
	$VBoxContainer/Icon.modulate = color

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
	var new_pos = -80 if !reverse_popup else 45
	tween.tween_property($TradeHBox, "position:y", new_pos, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	_bubble_displayed=true
	match res:
		1:	$TradeHBox/TextureButton/TextureRect.texture = load("res://assets/poivre.png")
		2:	$TradeHBox/TextureButton/TextureRect.texture = load("res://assets/icons/ettoffe.png")
		3:	$TradeHBox/TextureButton/TextureRect.texture = load("res://assets/ivoire.png")
		4:	$TradeHBox/TextureButton/TextureRect.texture = load("res://assets/icons/Coton.png")
		5:	$TradeHBox/TextureButton/TextureRect.texture = load("res://assets/icons/pierres.png")
		6:	$TradeHBox/TextureButton/TextureRect.texture = load("res://assets/icons/epices.png")
		7:	$TradeHBox/TextureButton/TextureRect.texture = load("res://assets/icons/chevaux.png")

func hide_popup():
	if not _bubble_displayed:
		return
	var tween = create_tween()
	tween.tween_property($TradeHBox, "modulate:a", 0, 0.5)
	_bubble_displayed=false
	await tween.finished
