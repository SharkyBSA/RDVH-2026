extends Control
class_name Town

@export var town_name := ""
@export var transport_on_sea := false
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

#func _process(_delta):
	#if Input.is_action_just_pressed("escape"): get_tree().free()

func _on_texture_button_pressed():
	emit_signal("clicked", town_name, current_offer, transport_turn)
	$AudioStreamPlayer.stream = sfx[randi_range(0, sfx.size()-1)]
	$AudioStreamPlayer.play()

## Show the popup to start a trade. If type is 0, hides the down. 1, hides the up. 2, show both.
func popup(type := 0):
	$TradeHBox/ArrowUp.visible = true if type == 0 else false
	$TradeHBox/ArrowDown.visible = true if type == 1 else false
	# Animation
	$TradeHBox.position.y = 0
	$TradeHBox.modulate.a = 1
	var tween = create_tween()
	var new_pos = -80 if !reverse_popup else 45
	tween.tween_property($TradeHBox, "position:y", new_pos, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	_bubble_displayed=true
	match type:
		0:	$TradeHBox/TextureButton/TextureRect.texture = load("res://assets/poivre.png")

func hide_popup():
	if not _bubble_displayed:
		return
	var tween = create_tween()
	tween.tween_property($TradeHBox, "modulate:a", 0, 0.5)
	_bubble_displayed=false
	await tween.finished
