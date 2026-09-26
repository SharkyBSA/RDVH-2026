extends Control
class_name Town

@export var town_name := ""
@export var transport_on_sea := false
@export var transport_turn := 1
@export var transport_threat := 0
@export var threat_level := 0
var res_type := 0
var res_amount := 0
var added_threat := 0
signal clicked(display_name, resource, amount, threat)

func _ready():
	$VBoxContainer/TownName.text = town_name
	$VBoxContainer/TownName.modulate = Color(0.7, 0, 0)
	$VBoxContainer/Icon.modulate = Color(0.7, 0, 0)

func _process(_delta):
	if Input.is_action_just_pressed("escape"): get_tree().free()

func _on_texture_button_pressed():
	emit_signal("clicked", town_name, res_type, res_amount, added_threat, transport_turn)

## Show the popup to start a trade. If type is 0, hides the down. 1, hides the up. 2, show both.
func popup(type := 0):
	$TradeHBox/ArrowUp.visible = true if type == 0 else false
	$TradeHBox/ArrowDown.visible = true if type == 1 else false
	# Animation
	$TradeHBox.position.y = 0
	$TradeHBox.modulate.a = 1
	$TradeHBox.show()
	var tween = create_tween()
	tween.tween_property($TradeHBox, "position:y", -80, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)

func hide_popup():
	var tween = create_tween()
	tween.tween_property($TradeHBox, "modulate:a", 0, 0.5)
